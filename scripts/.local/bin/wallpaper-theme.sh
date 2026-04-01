#!/bin/bash
# Unified wallpaper + theme engine
# Usage: wallpaper-theme.sh [next|prev|select|set <path>|restore]

WALLDIR=~/Pictures/wallpapers
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/hypr-theme"
STATE_FILE="$CACHE_DIR/wallpaper-index"
LAST_WALL_FILE="$CACHE_DIR/last-wallpaper"

mkdir -p "$CACHE_DIR"

apply_theme() {
    local WALL="$1"
    [ ! -f "$WALL" ] && echo "Wallpaper not found: $WALL" && exit 1

    # Save state
    echo "$WALL" > "$LAST_WALL_FILE"

    # Set wallpaper via hyprpaper
    hyprctl hyprpaper preload "$WALL" 2>/dev/null
    hyprctl hyprpaper wallpaper ",$WALL" 2>/dev/null

    # Generate colors with matugen (avoids red-ish primaries)
    WALL="$WALL" ~/.local/bin/matugen-safe.sh "$WALL"

    # Source new Hyprland colors (border colors update)
    hyprctl reload 2>/dev/null

    # Rebuild waybar stylesheet: base + generated colors
    cat ~/.config/waybar/base.css ~/.config/waybar/themes/generated.css > ~/.config/waybar/style.css
    killall -SIGUSR2 waybar 2>/dev/null || (killall waybar 2>/dev/null; waybar &)

    # Rebuild wofi stylesheet: base + generated colors
    if [ -f ~/.config/wofi/colors-generated.css ]; then
        cat ~/.config/wofi/base.css ~/.config/wofi/colors-generated.css > ~/.config/wofi/style.css
    fi

    # Reload mako with generated colors
    if [ -f ~/.config/mako/colors-generated ]; then
        makoctl reload 2>/dev/null
    fi

    # Update Papirus folder icon color to match primary
    PRIMARY_HEX=$(grep -oP 'accent_bg_color \K#[0-9a-fA-F]+' ~/.config/gtk-3.0/gtk.css 2>/dev/null)
    if [ -n "$PRIMARY_HEX" ] && command -v papirus-folders &>/dev/null; then
        FOLDER_COLOR=$(python3 ~/.local/bin/closest-papirus-color.py "$PRIMARY_HEX")
        papirus-folders -C "$FOLDER_COLOR" -t Papirus-Dark --once 2>/dev/null
    fi

    # Reload GTK apps (Thunar, etc.) to pick up new colors
    gsettings set org.gnome.desktop.interface gtk-theme '' 2>/dev/null
    gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark' 2>/dev/null

    # Update VSCodium colors
    python3 ~/.local/bin/update-vscode-colors.py 2>/dev/null

    # Reload tmux colors
    tmux source-file ~/.tmux.conf 2>/dev/null

    notify-send "Theme" "Applied colors from $(basename "$WALL")" -t 2000
}

get_walls() {
    find "$WALLDIR" -maxdepth 1 -type f \( -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" -o -name "*.webp" \) | sort
}

case "${1:-next}" in
    next)
        mapfile -t WALLS < <(get_walls)
        [ ${#WALLS[@]} -eq 0 ] && exit 1
        INDEX=$(cat "$STATE_FILE" 2>/dev/null || echo -1)
        INDEX=$(( (INDEX + 1) % ${#WALLS[@]} ))
        echo "$INDEX" > "$STATE_FILE"
        apply_theme "${WALLS[$INDEX]}"
        ;;
    prev)
        mapfile -t WALLS < <(get_walls)
        [ ${#WALLS[@]} -eq 0 ] && exit 1
        INDEX=$(cat "$STATE_FILE" 2>/dev/null || echo 1)
        INDEX=$(( (INDEX - 1 + ${#WALLS[@]}) % ${#WALLS[@]} ))
        echo "$INDEX" > "$STATE_FILE"
        apply_theme "${WALLS[$INDEX]}"
        ;;
    select)
        # Visual picker is now handled by wallpaper-select.sh
        # Fallback: call it directly
        exec ~/.local/bin/wallpaper-select.sh
        ;;
    set)
        [ -z "$2" ] && echo "Usage: wallpaper-theme.sh set <path>" && exit 1
        apply_theme "$2"
        ;;
    restore)
        if [ -f "$LAST_WALL_FILE" ]; then
            WALL=$(cat "$LAST_WALL_FILE")
            if [ -f "$WALL" ]; then
                sleep 1  # wait for hyprpaper to initialize
                apply_theme "$WALL"
                exit 0
            fi
        fi
        # No saved wallpaper — generate from default
        apply_theme "$WALLDIR/wall0.png"
        ;;
    *)
        echo "Usage: wallpaper-theme.sh [next|prev|select|set <path>|restore]"
        exit 1
        ;;
esac
