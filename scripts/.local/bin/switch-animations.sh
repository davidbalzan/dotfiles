#!/bin/bash
# Cycle through animation presets
PRESET_DIR="$HOME/.config/hypr/animations"
STATE_FILE="$HOME/.cache/hypr-animation-preset"
PRESETS=(smooth snappy minimal)

CURRENT=$(cat "$STATE_FILE" 2>/dev/null || echo "smooth")

# Find next preset
for i in "${!PRESETS[@]}"; do
    if [ "${PRESETS[$i]}" = "$CURRENT" ]; then
        NEXT_IDX=$(( (i + 1) % ${#PRESETS[@]} ))
        break
    fi
done

NEXT="${PRESETS[$NEXT_IDX]}"
echo "$NEXT" > "$STATE_FILE"

cp "$PRESET_DIR/$NEXT.conf" "$HOME/.config/hypr/animations.conf"
hyprctl reload

notify-send "Animations" "Switched to $NEXT preset" -t 2000
