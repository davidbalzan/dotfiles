#!/bin/bash
EMOJI_FILE="$HOME/.local/share/emoji-list.txt"

if [ ! -f "$EMOJI_FILE" ]; then
    # Generate emoji list from unicode data
    python3 -c "
import unicodedata
emojis = []
for c in range(0x1F600, 0x1F650):
    ch = chr(c)
    try:
        name = unicodedata.name(ch)
        emojis.append(f'{ch} {name}')
    except ValueError:
        pass
for c in range(0x1F680, 0x1F6D0):
    ch = chr(c)
    try:
        name = unicodedata.name(ch)
        emojis.append(f'{ch} {name}')
    except ValueError:
        pass
for c in range(0x2600, 0x2700):
    ch = chr(c)
    try:
        name = unicodedata.name(ch)
        emojis.append(f'{ch} {name}')
    except ValueError:
        pass
for c in range(0x1F300, 0x1F5FF):
    ch = chr(c)
    try:
        name = unicodedata.name(ch)
        emojis.append(f'{ch} {name}')
    except ValueError:
        pass
print('\n'.join(emojis))
" > "$EMOJI_FILE"
fi

CHOICE=$(cat "$EMOJI_FILE" | rofi -dmenu -i -p "Emoji" \
    -theme-str 'window {width: 40%; height: 50%;}' \
    -theme-str 'listview {lines: 12;}' \
    -theme ~/.config/rofi/wallpaper-picker.rasi)

[ -z "$CHOICE" ] && exit 0

# Extract just the emoji character
EMOJI=$(echo "$CHOICE" | cut -d' ' -f1)
echo -n "$EMOJI" | wl-copy
notify-send "Emoji" "$EMOJI copied" -t 1500
