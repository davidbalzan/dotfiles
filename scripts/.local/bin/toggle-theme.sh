#!/bin/bash
# Toggle between dark and light theme for Waybar and Hyprland borders

STATE_FILE="$HOME/.config/theme-mode"
CURRENT=$(cat "$STATE_FILE" 2>/dev/null || echo "dark")

if [ "$CURRENT" = "dark" ]; then
    MODE="light"
else
    MODE="dark"
fi

echo "$MODE" > "$STATE_FILE"

# --- Waybar ---
cp "$HOME/.config/waybar/style-${MODE}.css" "$HOME/.config/waybar/style.css"
killall -SIGUSR2 waybar 2>/dev/null || (killall waybar 2>/dev/null; waybar &)

# --- Hyprland borders ---
if [ "$MODE" = "light" ]; then
    hyprctl keyword general:col.active_border "rgba(1e66f5ee) rgba(8839efee) 45deg"
    hyprctl keyword general:col.inactive_border "rgba(ccd0daaa)"
else
    hyprctl keyword general:col.active_border "rgba(89b4faee) rgba(cba6f7ee) 45deg"
    hyprctl keyword general:col.inactive_border "rgba(313244aa)"
fi

notify-send "Theme" "Switched to ${MODE} mode" -t 2000
