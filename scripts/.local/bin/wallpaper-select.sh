#!/bin/bash
# Visual wallpaper picker using rofi with image thumbnails
# Single click to select, themed to match wallpaper colors

WALLDIR=~/Pictures/wallpapers
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/hypr-theme/thumbs"
THUMB_SIZE=200

mkdir -p "$CACHE_DIR"

# Generate thumbnails for any new/changed wallpapers
for wall in "$WALLDIR"/*.{png,jpg,jpeg,webp}; do
    [ -f "$wall" ] || continue
    name=$(basename "$wall")
    thumb="$CACHE_DIR/${name%.*}.sqre.png"
    if [ -f "$thumb" ] && [ "$thumb" -nt "$wall" ]; then
        continue
    fi
    magick "$wall" -resize "${THUMB_SIZE}x${THUMB_SIZE}^" \
        -gravity center -extent "${THUMB_SIZE}x${THUMB_SIZE}" \
        "$thumb" 2>/dev/null &
done
wait

# Build rofi entries and show picker (single click to select)
CHOICE=$(
    for wall in "$WALLDIR"/*.{png,jpg,jpeg,webp}; do
        [ -f "$wall" ] || continue
        name=$(basename "$wall")
        thumb="$CACHE_DIR/${name%.*}.sqre.png"
        [ -f "$thumb" ] || continue
        printf '%s\0icon\x1f%s\n' "$name" "$thumb"
    done | rofi -dmenu \
        -show-icons \
        -theme ~/.config/rofi/wallpaper-picker.rasi \
        -me-select-entry '' \
        -me-accept-entry 'MousePrimary'
)

[ -z "$CHOICE" ] && exit 0

exec ~/.local/bin/wallpaper-theme.sh set "$WALLDIR/$CHOICE"
