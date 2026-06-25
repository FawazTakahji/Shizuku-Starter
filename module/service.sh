MODDIR="${0%/*}"
USER_CONFIG_DIR="/data/adb/shizuku-starter"
USER_CONFIG_FILE="$USER_CONFIG_DIR/config.txt"
LOG_FILE="$USER_CONFIG_DIR/service.log"

echo "--- Shizuku Starter Boot Log ---" > "$LOG_FILE"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

show_notification() {
    su shell -c "cmd notification post -S bigtext -t 'Shizuku Starter' 'Tag' '$1'"
}

log "Waiting for boot completion..."

while [ "$(getprop sys.boot_completed)" != "1" ] && [ "$(getprop sys.boot_completed)" != "true" ]; do
    sleep 1
done

log "Boot completed, waiting 5 extra seconds..."
sleep 5

if [ ! -f "$USER_CONFIG_FILE" ]; then    
    if [ -f "$MODDIR/config.txt" ]; then
        mkdir -p "$USER_CONFIG_DIR"
        cp "$MODDIR/config.txt" "$USER_CONFIG_FILE"
        log "Config file created at $USER_CONFIG_FILE. Awaiting user configuration."
        show_notification "Please edit the config file at $USER_CONFIG_FILE to start Shizuku."
    else
        log "ERROR: Config file not found. Please reinstall the module."
        show_notification "Config file not found. Please reinstall the module."
    fi
    exit 1
fi

mode=$(sed -n 's/^mode=//p' "$USER_CONFIG_FILE")
libshizuku=$(sed -n 's/^libshizuku=//p' "$USER_CONFIG_FILE")

if [ -z "$libshizuku" ]; then
    log "ERROR: libshizuku path is empty in config."
    show_notification "libshizuku path is empty in config. Please edit the config file at $USER_CONFIG_FILE."
    exit 1
elif [ "$libshizuku" = "AUTO_SEARCH" ]; then
    log "Searching for libshizuku.so..."
    libshizuku=$(find /data/app/ -type f -name "libshizuku.so" 2>/dev/null | head -n 1)
fi

if [ ! -f "$libshizuku" ]; then
    log "ERROR: libshizuku.so not found at target path: $libshizuku"
    show_notification "libshizuku.so not found. Edit config with the correct path."
    exit 1
fi

chmod +x "$libshizuku"

if [ "$mode" = "root" ]; then
    log "Starting Shizuku as root..."
    "$libshizuku" 2>&1 > >(tee -a "$LOG_FILE")
    RET=$?
else
    log "Starting Shizuku as adb..."
    su shell -c "$libshizuku" 2>&1 > >(tee -a "$LOG_FILE")
    RET=$?
fi

if [ "$RET" -eq 0 ]; then
    log "Shizuku started successfully."
else
    log "Shizuku failed to start. Exit code: $RET"
    show_notification "Failed to start. Please check the log file at $LOG_FILE."
fi