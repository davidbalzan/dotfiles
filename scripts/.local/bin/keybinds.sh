#!/bin/bash
# Show Hyprland keybindings cheat sheet via wofi

cat << 'EOF' | wofi --dmenu --prompt "⌨ Keybindings" --width 500 --height 600 --cache-file /dev/null
── General ──────────────────
Super + Q         Terminal
Super + E         File Manager
Super + B         Browser
Super + D         App Launcher
Super + V         Clipboard History
Super + W         Cycle Wallpaper
Super + C         Close Window
Super + Shift+E   Exit Hyprland
Super + Shift+R   Reload Config

── Layout ──────────────────
Super + Shift+V   Toggle Float
Super + F         Maximize
Super + Shift+F   Fullscreen
Super + P         Pseudo Tile
Super + J         Toggle Split

── Focus (vim) ─────────────
Super + h/j/k/l   Focus L/D/U/R
Super + Arrows     Focus L/D/U/R

── Move Windows ────────────
Super+Shift + h/j/k/l   Move L/D/U/R

── Resize ──────────────────
Super+Ctrl + h/j/k/l    Resize

── Workspaces ──────────────
Super + 1-0        Switch WS 1-10
Super+Shift + 1-0  Move to WS 1-10
Super + Scroll     Cycle Workspaces
Super + S          Scratchpad
Super+Shift + S    To Scratchpad

── Mouse ───────────────────
Super + LMB        Move Window
Super + RMB        Resize Window

── Screenshot ──────────────
Print              Area Screenshot
Shift + Print      Full Screenshot

── Media ───────────────────
Vol Up/Down/Mute   Volume
Brightness Up/Down Screen Brightness
Play/Next/Prev     Media Controls
EOF
