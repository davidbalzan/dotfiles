# dotfiles

My Arch Linux + Hyprland rice. ASUS laptop with NVIDIA, Catppuccin-inspired theming, and a minimal Wayland workflow.

![Arch](https://img.shields.io/badge/Arch_Linux-1793D1?style=flat&logo=arch-linux&logoColor=white)
![Hyprland](https://img.shields.io/badge/Hyprland-58E1FF?style=flat&logo=hyprland&logoColor=black)
![License](https://img.shields.io/badge/License-MIT-green?style=flat)

## Overview

| Component | Tool |
|-----------|------|
| WM | [Hyprland](https://hyprland.org) |
| Bar | [Waybar](https://github.com/Alexays/Waybar) |
| Terminal | [Alacritty](https://alacritty.org) |
| Shell | zsh + [Starship](https://starship.rs) |
| Launcher | [Wofi](https://hg.sr.ht/~scoopta/wofi) + [Rofi](https://github.com/lbonn/rofi) (visual pickers) |
| Notifications | [Mako](https://github.com/emersion/mako) |
| Wallpaper | [Hyprpaper](https://github.com/hyprwm/hyprpaper) |
| Theming | [Matugen](https://github.com/InioX/matugen) (wallpaper-driven) |
| Lock | [Hyprlock](https://github.com/hyprwm/hyprlock) |
| Idle | [Hypridle](https://github.com/hyprwm/hypridle) |
| Logout | [Wlogout](https://github.com/ArtsyMacaw/wlogout) |
| File Manager | Thunar |
| Browser | Google Chrome |

## Features

- **Wallpaper-driven theming** — colors extracted from wallpapers via `matugen` and propagated to Hyprland, Waybar, Alacritty, Mako, Wofi, Rofi, GTK/Thunar, Papirus folder icons, tmux, and VSCodium
- **Red avoidance** — intelligent color fallback when wallpaper produces red-ish primary colors
- **Visual wallpaper picker** — rofi grid with 200px thumbnails, single-click to select and apply
- **Animation presets** — switch between smooth, snappy, and minimal animation profiles
- **Game mode** — one-key toggle to disable animations, blur, gaps, and opacity for gaming
- **Lock screen** — hyprlock with wallpaper background and adaptive colors
- **Logout menu** — wlogout with lock, logout, suspend, reboot, and shutdown
- **Screen recording** — toggle wf-recorder with region selection
- **Color picker** — hyprpicker with auto clipboard copy
- **Emoji picker** — rofi-based emoji grid
- **Window opacity rules** — tiered transparency: browsers 90%, terminals 85%, media 80%
- **Idle inhibit** — fullscreen browsers and media players prevent screen lock
- **Disk space** — root and data partition usage in Waybar
- **Modular Hyprland config** — split into focused files (monitors, keybindings, appearance, etc.)
- **Glassmorphism** — blur on Waybar, Wofi, Mako, and SwayOSD

## Keybindings

| Key | Action |
|-----|--------|
| `Super + Q` | Terminal |
| `Super + D` | App launcher |
| `Super + B` | Browser |
| `Super + E` | File manager |
| `Super + C` | Close window |
| `Super + F` | Fullscreen |
| `Super + H/J/K/L` | Focus (vim-style) |
| `Super + Shift + H/J/K/L` | Move window |
| `Super + 1-0` | Switch workspace |
| `Super + W` | Next wallpaper + theme |
| `Super + Shift + W` | Visual wallpaper picker |
| `Super + A` | Cycle animation preset |
| `Super + G` | Toggle game mode |
| `Super + L` | Lock screen |
| `Super + Shift + E` | Logout menu |
| `Super + U` | Toggle unattended mode |
| `Super + V` | Clipboard history |
| `Super + S` | Scratchpad |
| `Super + .` | Emoji picker |
| `Super + Shift + C` | Color picker |
| `Super + Shift + R` | Toggle screen recording |
| `Super + Ctrl + R` | Reload config |
| `Super + /` | Keybinding cheat sheet |
| `Print` | Screenshot (region) |
| `Shift + Print` | Screenshot (full) |

## Shell

zsh with modern replacements:

| Default | Replacement |
|---------|-------------|
| `ls` | `eza --icons` |
| `cat` | `bat` |
| `grep` | `ripgrep` |
| `find` | `fd` |
| `cd` | `zoxide` |

Plus `fzf` fuzzy finder, `zsh-autosuggestions`, and `zsh-syntax-highlighting`.

## Structure

```
dotfiles/
├── hypr/            # Hyprland (modular config)
├── waybar/          # Status bar + themes
├── alacritty/       # Terminal
├── mako/            # Notifications
├── wofi/            # App launcher
├── scripts/         # Utility scripts
├── tmux/            # Terminal multiplexer
├── matugen/         # Wallpaper-based color generation templates
├── zsh/             # Shell config
├── packages.txt     # Explicit pacman packages
└── install.sh       # Stow-based installer
```

## Install

**On a fresh Arch install:**

```bash
# Clone
git clone https://github.com/davidbalzan/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Install system packages
./install.sh --packages

# Symlink all configs
./install.sh

# Or symlink specific packages
./install.sh hypr waybar alacritty
```

Uses [GNU Stow](https://www.gnu.org/software/stow/) to create symlinks from the repo into `$HOME`. Running `stow -D <package>` in the repo directory will cleanly remove the symlinks.

## Portability

Most of this config is hardware-agnostic. A few files may need adjusting on different machines:

- **`monitors.conf`** — resolution, refresh rate, and scaling
- **`environment.conf`** — GPU-specific env vars (e.g. NVIDIA vs AMD/Intel)
- **`autostart.conf`** — vendor-specific tools (e.g. `asusctl` for ASUS keyboards)

Everything else (Waybar, Alacritty, theming, matugen, scripts, zsh, tmux) works on any Arch + Hyprland setup.
