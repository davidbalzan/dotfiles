#!/bin/bash
# Toggle unattended mode for long-running tasks
# Lowers power usage, dims/turns off screen, preserves battery

STATE_FILE="/tmp/unattended-mode-active"

activate() {
    echo "Activating unattended mode..."

    # Save current brightness
    brightnessctl -s

    # Start hypridle if not running
    pgrep -x hypridle || hypridle &

    # Set power-saver CPU governor
    if command -v powerprofilesctl &>/dev/null; then
        powerprofilesctl set power-saver
    fi

    # Reduce brightness to minimum
    brightnessctl set 5%

    # Turn off screen
    hyprctl dispatch dpms off

    # Stop non-essential tray apps to save resources
    killall -STOP telegram-desktop 2>/dev/null
    killall -STOP discord 2>/dev/null

    touch "$STATE_FILE"
    notify-send "Unattended Mode" "Activated - low power mode" 2>/dev/null
    echo "Unattended mode ON"
}

deactivate() {
    echo "Deactivating unattended mode..."

    # Screen on
    hyprctl dispatch dpms on

    # Restore brightness
    brightnessctl -r

    # Restore CPU profile
    if command -v powerprofilesctl &>/dev/null; then
        powerprofilesctl set balanced
    fi

    # Resume paused apps
    killall -CONT telegram-desktop 2>/dev/null
    killall -CONT discord 2>/dev/null

    rm -f "$STATE_FILE"
    notify-send "Unattended Mode" "Deactivated - normal mode" 2>/dev/null
    echo "Unattended mode OFF"
}

# Toggle
if [ -f "$STATE_FILE" ]; then
    deactivate
else
    activate
fi
