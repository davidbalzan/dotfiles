#!/bin/bash
COLOR=$(hyprpicker -a)
[ -n "$COLOR" ] && notify-send "Color Picker" "$COLOR copied to clipboard" -t 2000
