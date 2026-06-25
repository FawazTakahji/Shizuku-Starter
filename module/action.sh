MODDIR="${0%/*}"
USER_CONFIG_DIR="/data/adb/shizuku-starter"
USER_CONFIG_FILE="$USER_CONFIG_DIR/config.txt"

EDIT_MESSAGE="Please edit the config file at $USER_CONFIG_FILE to start Shizuku"

if ps -A | grep -q "[s]hizuku_server"; then
    echo "Shizuku is already running."
    exit 1
fi

if [ ! -f "$USER_CONFIG_FILE" ]; then    
    if [ -f "$MODDIR/config.txt" ]; then
        mkdir -p "$USER_CONFIG_DIR"
        cp "$MODDIR/config.txt" "$USER_CONFIG_FILE"
        echo "$EDIT_MESSAGE"
    else
        echo "Config file not found, please reinstall the module"
    fi

    exit 1
else
    mode=$(sed -n 's/^mode=//p' "$USER_CONFIG_FILE")
    libshizuku=$(sed -n 's/^libshizuku=//p' "$USER_CONFIG_FILE")

    if [ -z "$libshizuku" ]; then
        echo "$EDIT_MESSAGE"
        exit 1
    elif [ "$libshizuku" == "AUTO_SEARCH" ]; then
        echo "Searching for libshizuku.so..."
        libshizuku=$(find /data/app/ -type f -name "libshizuku.so" 2>/dev/null | head -n 1)
    fi

    if [ ! -f "$libshizuku" ]; then
        echo "libshizuku.so not found, edit the config file to point to the correct path"
        exit 1
    fi

    chmod +x "$libshizuku"
    if [ "$mode" == "root" ]; then
        echo "Starting Shizuku as root"
        "$libshizuku"
    else
        echo "Starting Shizuku as adb"
        su shell -c "$libshizuku"
    fi
fi