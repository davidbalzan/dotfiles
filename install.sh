#!/bin/bash
# Dotfiles installer — uses GNU Stow to symlink configs into $HOME
# Usage: ./install.sh [package...]
# If no packages specified, installs all packages.

set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
PACKAGES=(hypr waybar alacritty mako wofi scripts zsh)

install_packages() {
    local targets=("$@")
    if [ ${#targets[@]} -eq 0 ]; then
        targets=("${PACKAGES[@]}")
    fi

    for pkg in "${targets[@]}"; do
        if [ -d "$DOTFILES_DIR/$pkg" ]; then
            echo "Stowing $pkg..."
            stow -d "$DOTFILES_DIR" -t "$HOME" --adopt "$pkg"
        else
            echo "Package '$pkg' not found, skipping."
        fi
    done
}

install_system_packages() {
    echo "Installing system packages..."
    if command -v pacman &>/dev/null; then
        sudo pacman -S --needed - < "$DOTFILES_DIR/packages.txt"
    else
        echo "Not an Arch system — install packages manually from packages.txt"
        return 1
    fi
}

case "${1:-}" in
    --packages)
        install_system_packages
        ;;
    --help)
        echo "Usage: ./install.sh [--packages] [--help] [package...]"
        echo ""
        echo "  --packages    Install system packages from packages.txt"
        echo "  --help        Show this help"
        echo "  package...    Stow specific packages (default: all)"
        echo ""
        echo "Available packages: ${PACKAGES[*]}"
        ;;
    *)
        install_packages "$@"
        ;;
esac
