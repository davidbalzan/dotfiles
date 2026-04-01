#!/bin/bash
# Restore last theme mode on Hyprland startup

STATE_FILE="$HOME/.config/theme-mode"
MODE=$(cat "$STATE_FILE" 2>/dev/null || echo "dark")

# --- Waybar ---
cp "$HOME/.config/waybar/style-${MODE}.css" "$HOME/.config/waybar/style.css"

# --- Hyprland borders ---
if [ "$MODE" = "light" ]; then
    hyprctl keyword general:col.active_border "rgba(1e66f5ee) rgba(8839efee) 45deg"
    hyprctl keyword general:col.inactive_border "rgba(ccd0daaa)"
else
    hyprctl keyword general:col.active_border "rgba(89b4faee) rgba(cba6f7ee) 45deg"
    hyprctl keyword general:col.inactive_border "rgba(313244aa)"
fi
