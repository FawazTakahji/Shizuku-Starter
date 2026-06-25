USER_CONFIG_DIR="/data/adb/shizuku-starter"

rm -f "$USER_CONFIG_DIR/config.txt"
rm -f "$USER_CONFIG_DIR/service.log"
if [ -d "$USER_CONFIG_DIR" ]; then
    rmdir "$USER_CONFIG_DIR"
fi

# Don't modify anything after this
if [ -f $INFO ]; then
  while read LINE; do
    if [ "$(echo -n $LINE | tail -c 1)" == "~" ]; then
      continue
    elif [ -f "$LINE~" ]; then
      mv -f $LINE~ $LINE
    else
      rm -f $LINE
      while true; do
        LINE=$(dirname $LINE)
        [ "$(ls -A $LINE 2>/dev/null)" ] && break 1 || rm -rf $LINE
      done
    fi
  done < $INFO
  rm -f $INFO
fi