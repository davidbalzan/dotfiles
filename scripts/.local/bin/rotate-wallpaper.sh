#!/bin/bash
WALLDIR=~/Pictures/wallpapers
STATE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/hyprpaper"
STATE_FILE="$STATE_DIR/wallpaper-index"
LAST_WALL_FILE="$STATE_DIR/last-wallpaper"

mkdir -p "$STATE_DIR"

mapfile -t WALLS < <(find "$WALLDIR" -type f \( -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" -o -name "*.webp" \) | sort)

[ ${#WALLS[@]} -eq 0 ] && exit 1

INDEX=$(cat "$STATE_FILE" 2>/dev/null || echo 0)
INDEX=$(( (INDEX + 1) % ${#WALLS[@]} ))
echo "$INDEX" > "$STATE_FILE"

WALL="${WALLS[$INDEX]}"
echo "$WALL" > "$LAST_WALL_FILE"
hyprctl hyprpaper preload "$WALL"
hyprctl hyprpaper wallpaper ",$WALL"
