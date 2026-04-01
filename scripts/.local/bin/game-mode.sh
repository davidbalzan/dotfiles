#!/bin/bash
STATE="$HOME/.cache/hypr-game-mode"

if [ -f "$STATE" ]; then
    # Disable game mode
    rm "$STATE"
    hyprctl reload
    notify-send "Game Mode" "OFF — animations restored" -t 2000
else
    # Enable game mode
    touch "$STATE"
    hyprctl keyword animations:enabled false
    hyprctl keyword decoration:blur:enabled false
    hyprctl keyword decoration:active_opacity 1.0
    hyprctl keyword decoration:inactive_opacity 1.0
    hyprctl keyword decoration:rounding 0
    hyprctl keyword general:gaps_in 0
    hyprctl keyword general:gaps_out 0
    notify-send "Game Mode" "ON — performance mode" -t 2000
fi
