#!/bin/bash
# Restore last wallpaper on Hyprland startup
LAST_WALL_FILE="${XDG_CACHE_HOME:-$HOME/.cache}/hyprpaper/last-wallpaper"

if [ -f "$LAST_WALL_FILE" ]; then
    WALL=$(cat "$LAST_WALL_FILE")
    if [ -f "$WALL" ]; then
        sleep 1  # wait for hyprpaper to initialize
        hyprctl hyprpaper preload "$WALL"
        hyprctl hyprpaper wallpaper ",$WALL"
        exit 0
    fi
fi
# No saved wallpaper or file missing — hyprpaper defaults apply
