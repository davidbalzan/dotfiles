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
| Launcher | [Wofi](https://hg.sr.ht/~scoopta/wofi) |
| Notifications | [Mako](https://github.com/emersion/mako) |
| Wallpaper | [Hyprpaper](https://github.com/hyprwm/hyprpaper) |
| Theming | [Matugen](https://github.com/InioX/matugen) |
| Idle | [Hypridle](https://github.com/hyprwm/hypridle) |
| File Manager | Thunar |
| Browser | Google Chrome |

## Features

- **Light/dark theme toggle** with auto-propagation to Waybar, Alacritty, Wofi, and Mako
- **Wallpaper-driven theming** — colors extracted from wallpapers via `matugen`
- **Animation presets** — switch between smooth, snappy, and minimal animation profiles
- **Unattended mode** — one-key toggle for low-power operation (dims screen, power-saver CPU, pauses tray apps)
- **Modular Hyprland config** — split into focused files (monitors, keybindings, appearance, etc.)
- **Glassmorphism** — blur on Waybar and Wofi for a translucent look

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
| `Super + Shift + W` | Select wallpaper |
| `Super + A` | Cycle animation preset |
| `Super + U` | Toggle unattended mode |
| `Super + V` | Clipboard history |
| `Super + S` | Scratchpad |
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
