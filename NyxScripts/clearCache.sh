#!/bin/bash
while true; do
    size=$(du -sm ~/.cache/ | awk '{print $1}')


    if [ "$size" -ge 1000 ]; then
        rm -rf ~/.cache/*
    fi
    sleep 900 
done

