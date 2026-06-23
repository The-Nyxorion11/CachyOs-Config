#!/bin/bash
while true; do
    size=$(du -sm ~/.cache/ | awk '{print $1}')
    if [ "$size" -ge 1000 ]; then
        find ~/.cache/ -mindepth 1 -maxdepth 1 -not -name "wall-cache" -exec rm -rf {} +
        notify-send "Cache Liberado" "Cache limpiado correctamente"
    fi
    sleep 900 
done
