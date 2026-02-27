#!/usr/bin/env bash
set -e

# ──────────────────────────────────────────────────────────────
# Dotfiles Setup Script
# Installs dependencies, stows configs, and sets up environment
# ──────────────────────────────────────────────────────────────

BOLD='\033[1m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

info()  { echo -e "${GREEN}[✓]${NC} $1"; }
warn()  { echo -e "${YELLOW}[!]${NC} $1"; }
error() { echo -e "${RED}[✗]${NC} $1"; exit 1; }
ask()   { echo -ne "${BOLD}[?]${NC} $1 [y/N] "; read -r ans; [[ "$ans" =~ ^[Yy]$ ]]; }

# ── Check we're on Arch ──────────────────────────────────────
if ! command -v pacman &>/dev/null; then
    error "This script is designed for Arch Linux (pacman not found)."
fi

# ── Check for AUR helper ─────────────────────────────────────
AUR=""
if command -v yay &>/dev/null; then
    AUR="yay"
elif command -v paru &>/dev/null; then
    AUR="paru"
else
    warn "No AUR helper (yay/paru) found. AUR packages will be skipped."
    warn "You'll need to install these manually: grimblast-git cliphist hyprpolkitagent bibata-cursor-theme"
fi

echo ""
echo -e "${BOLD}╔══════════════════════════════════════╗${NC}"
echo -e "${BOLD}║        Dotfiles Setup Script         ║${NC}"
echo -e "${BOLD}╚══════════════════════════════════════╝${NC}"
echo ""

# ── Install pacman packages ───────────────────────────────────
PACMAN_PKGS=(
    hyprland waybar wofi dunst alacritty zsh neovim
    hyprpaper hyprlock hypridle
    wl-clipboard brightnessctl playerctl thunar stow
    pavucontrol blueman nm-connection-editor networkmanager
    ttf-roboto-mono ttf-font-awesome
    pipewire wireplumber
)

info "Installing core packages..."
sudo pacman -S --needed --noconfirm "${PACMAN_PKGS[@]}"

# ── Install AUR packages ─────────────────────────────────────
AUR_PKGS=(
    grimblast-git
    cliphist
    hyprpolkitagent
    bibata-cursor-theme
)

if [[ -n "$AUR" ]]; then
    info "Installing AUR packages via $AUR..."
    $AUR -S --needed --noconfirm "${AUR_PKGS[@]}"
fi

# ── Stow dotfiles ────────────────────────────────────────────
DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

info "Stowing dotfiles from $DOTFILES_DIR..."
cd "$DOTFILES_DIR"
stow base

# ── Environment config ────────────────────────────────────────
ENV_CONF="$HOME/.config/hypr/conf.d/env.conf"
ENV_EXAMPLE="$HOME/.config/hypr/conf.d/env.conf.example"

if [[ ! -f "$ENV_CONF" ]]; then
    if ask "No env.conf found. Do you have an NVIDIA GPU?"; then
        cat > "$ENV_CONF" <<'EOF'
env = LIBVA_DRIVER_NAME,nvidia
env = __GLX_VENDOR_LIBRARY_NAME,nvidia
env = __GL_VRR_ALLOWED,0
env = XCURSOR_SIZE,24
env = HYPRCURSOR_SIZE,24
EOF
        info "Created env.conf with NVIDIA settings."
    else
        cp "$ENV_EXAMPLE" "$ENV_CONF"
        info "Created env.conf from example (non-NVIDIA)."
    fi
else
    warn "env.conf already exists, skipping."
fi

# ── Secret keybinds ───────────────────────────────────────────
SECRET_CONF="$HOME/.config/hypr/conf.d/secret.conf"
if [[ ! -f "$SECRET_CONF" ]]; then
    touch "$SECRET_CONF"
    info "Created empty secret.conf for private keybinds."
fi

# ── Enable services ───────────────────────────────────────────
info "Enabling NetworkManager..."
sudo systemctl enable --now NetworkManager 2>/dev/null || true

if command -v bluetoothctl &>/dev/null; then
    info "Enabling Bluetooth..."
    sudo systemctl enable --now bluetooth 2>/dev/null || true
fi

# ── Make scripts executable ───────────────────────────────────
info "Setting script permissions..."
chmod +x "$HOME/.config/hypr/scripts/"*.sh 2>/dev/null || true
chmod +x "$HOME/.config/waybar/scripts/"*.sh 2>/dev/null || true
chmod +x "$HOME/.config/waybar/"*.sh 2>/dev/null || true

# ── Done ──────────────────────────────────────────────────────
echo ""
echo -e "${GREEN}${BOLD}Setup complete!${NC}"
echo ""
echo "  Next steps:"
echo "    1. Log out and select Hyprland from your display manager"
echo "    2. Or run 'Hyprland' from a TTY"
echo ""
echo "  Optional:"
echo "    • Edit ~/.config/hypr/conf.d/secret.conf for private keybinds"
echo "    • Edit ~/.config/hypr/hyprland.conf to change monitor settings"
echo ""
