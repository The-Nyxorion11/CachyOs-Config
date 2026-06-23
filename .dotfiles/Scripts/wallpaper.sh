#!/bin/bash
awww-daemon &
sleep 3
WALL=$(readlink -f ~/.cache/wall-cache/current_wallpaper)
if [ -f "$WALL" ]; then
    awww img "$WALL" --transition-type none
fi
