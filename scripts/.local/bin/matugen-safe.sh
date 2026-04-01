#!/bin/bash
# Wrapper around matugen that avoids red-ish primary colors
# Tries preferences; if all give red, regenerates from tertiary color

WALL="$1"

is_red() {
    python3 -c "
import colorsys,sys
h=sys.argv[1].lstrip('#')
r,g,b=int(h[0:2],16)/255,int(h[2:4],16)/255,int(h[4:6],16)/255
hue,_,sat=colorsys.rgb_to_hls(r,g,b)
sys.exit(0 if (hue<0.08 or hue>0.92) and sat>0.3 else 1)
" "$1" 2>/dev/null
}

get_primary() {
    grep -oP 'accent_bg_color \K#[0-9a-fA-F]+' ~/.config/gtk-3.0/gtk.css 2>/dev/null
}

get_tertiary() {
    grep -oP 'warning_bg_color \K#[0-9a-fA-F]+' ~/.config/gtk-3.0/gtk.css 2>/dev/null
}

# Try saturation (default)
matugen image "$WALL" --prefer saturation 2>/dev/null
is_red "$(get_primary)" || exit 0

# Try darkness
matugen image "$WALL" --prefer darkness 2>/dev/null
is_red "$(get_primary)" || exit 0

# Try lightness
matugen image "$WALL" --prefer lightness 2>/dev/null
is_red "$(get_primary)" || exit 0

# All red — regenerate entire scheme from the tertiary color
TERTIARY=$(get_tertiary)
if [ -n "$TERTIARY" ] && ! is_red "$TERTIARY"; then
    matugen color hex "$TERTIARY" 2>/dev/null
else
    # Even tertiary is red — try secondary
    SECONDARY=$(grep -oP 'success_bg_color \K#[0-9a-fA-F]+' ~/.config/gtk-3.0/gtk.css 2>/dev/null)
    if [ -n "$SECONDARY" ] && ! is_red "$SECONDARY"; then
        matugen color hex "$SECONDARY" 2>/dev/null
    fi
    # If everything is red, keep saturation result (genuinely red wallpaper)
fi
