#!/bin/bash
# Hyprland & Core Dependencies Installer
# Installs Hyprland, Waybar, Eww, and other required tools for the dotfiles.

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="$DOTFILES_DIR/install-hyprland.log"

# -- Dependencies Lists --

# Official packages (Arch Extra/Core)
OFFICIAL_PACKAGES=(
    "hyprland"
    "hypridle"
    "hyprlock"
    "xdg-desktop-portal-hyprland"
    "waybar"
    "mako"              # Notification daemon
    "jq"                # JSON processor (required for scripts)
    "socat"             # Socket tool (required for which-key-daemon)
    "playerctl"         # Media control
    "wl-clipboard"      # Clipboard tools
    "grim"              # Screenshot tool
    "slurp"             # Region selector for screenshots
    "polkit-kde-agent"  # Auth agent (common choice)
    "ttf-nerd-fonts-symbols" # Icons
    "brightnessctl"     # Brightness control (often needed)
    "pamixer"           # Volume control (often needed)
)

# AUR packages (might need yay/paru)
AUR_PACKAGES=(
    "eww"               # Widget system (required for which-key)
    "swayosd-git"       # OSD for volume/caps/etc
    "rofi-wayland"      # App launcher (Wayland fork)
    "hyprsunset"        # Blue light filter
)

# -- Helpers --

log() {
    echo "[$1] $2" | tee -a "$LOG_FILE"
}

check_cmd() {
    command -v "$1" >/dev/null 2>&1
}

# -- Main Script --

echo "========================================"
echo "Hyprland Environment Setup"
echo "========================================"
echo "Logs: $LOG_FILE"
echo ""

# 1. Detect AUR Helper
echo "[1/5] Detecting Package Manager..."
AUR_HELPER=""
if check_cmd yay; then
    AUR_HELPER="yay"
elif check_cmd paru; then
    AUR_HELPER="paru"
fi

if [[ -z "$AUR_HELPER" ]]; then
    log "WARN" "No AUR helper (yay/paru) found."
    log "WARN" "Will only install official packages using sudo pacman."
    log "WARN" "You will need to manually install: ${AUR_PACKAGES[*]}"
else
    log "INFO" "Using AUR helper: $AUR_HELPER"
fi

# 2. Install Official Packages
echo "[2/5] Installing Official Packages..."
TO_INSTALL=()
for pkg in "${OFFICIAL_PACKAGES[@]}"; do
    if ! pacman -Qi "$pkg" >/dev/null 2>&1; then
        TO_INSTALL+=("$pkg")
    fi
done

if [[ ${#TO_INSTALL[@]} -gt 0 ]]; then
    log "INFO" "Installing: ${TO_INSTALL[*]}"
    if [[ -n "$AUR_HELPER" ]]; then
        "$AUR_HELPER" -S --needed --noconfirm "${TO_INSTALL[@]}"
    else
        sudo pacman -S --needed --noconfirm "${TO_INSTALL[@]}"
    fi
else
    log "INFO" "All official packages already installed."
fi

# 3. Install AUR Packages
echo "[3/5] Installing AUR Packages..."
if [[ -n "$AUR_HELPER" ]]; then
    TO_INSTALL_AUR=()
    for pkg in "${AUR_PACKAGES[@]}"; do
        if ! pacman -Qi "$pkg" >/dev/null 2>&1; then
            TO_INSTALL_AUR+=("$pkg")
        fi
    done

    if [[ ${#TO_INSTALL_AUR[@]} -gt 0 ]]; then
        log "INFO" "Installing AUR packages: ${TO_INSTALL_AUR[*]}"
        "$AUR_HELPER" -S --needed --noconfirm "${TO_INSTALL_AUR[@]}"
    else
        log "INFO" "All AUR packages already installed."
    fi
else
    log "SKIP" "Skipping AUR packages (no helper found)."
fi

# 4. Stow Configurations
echo "[4/5] Stowing configurations..."
cd "$DOTFILES_DIR"

# Ensure git is clean or use --adopt if needed, mirroring install-webapps.sh approach?
# For now, simple stow.
PACKAGES_TO_STOW=(
    "hyprland"
    "waybar"
    # "rofi" - config is in i3/rofi? Let's check where it is.
    # checking directory listing: i3/.config/rofi exists. 
    # If hyprland uses rofi, it likely uses the same config or I should check if there's a hyprland specific one.
    # The file tree shows i3/.config/rofi. Hyprland likely uses that or has its own.
    # Assuming the user wants Hyprland, we should stow hyprland folder.
)

for pkg in "${PACKAGES_TO_STOW[@]}"; do
    if [[ -d "$pkg" ]]; then
        log "INFO" "Stowing $pkg..."
        stow -R "$pkg"
    else
        log "WARN" "Directory $pkg not found, skipping stow."
    fi
done

# 5. Final Setup & Checks
echo "[5/5] Finalizing..."

# Check if which-key-daemon is executable
if [[ -f "$HOME/.config/eww/which-key-daemon.sh" ]]; then
    chmod +x "$HOME/.config/eww/which-key-daemon.sh"
    log "INFO" "Made which-key-daemon.sh executable."
fi

# Reload daemons if running
if pgrep -x "hyprland" >/dev/null; then
    log "INFO" "Hyprland is running. Reloading configuration..."
    hyprctl reload
fi

if pgrep -x "eww" >/dev/null; then
    log "INFO" "Reloading eww..."
    eww reload
fi

echo ""
echo "========================================"
echo "Installation Complete!"
echo "========================================"
if [[ -z "$AUR_HELPER" ]]; then
    echo "REMINDER: You still need to install these AUR packages manually:"
    echo "  ${AUR_PACKAGES[*]}"
fi
echo "Please restart Hyprland to apply all changes."
