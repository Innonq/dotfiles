# My Dotfiles

A minimal and unified dotfiles configuration centered around **Hyprland** with a dark Gruvbox and Beige accent theme.

## Components

- **Window Manager**: [Hyprland](https://hyprland.org)
- **Bar**: [Waybar](https://github.com/Alexays/Waybar)
- **App Launcher**: [Wofi](https://hg.sr.ht/~scoopta/wofi)
- **Notifications**: [Dunst](https://dunst-project.org/)
- **Terminal Emulator**: [Alacritty](https://github.com/alacritty/alacritty) (with [Zsh](https://www.zsh.org/))
- **Editor**: [Neovim](https://neovim.io/)

## Theme Specifications

All UI components are unified under a specific aesthetic:
- **Font**: `Roboto Mono` / `Font Awesome`
- **Border Radius**: `8px`
- **Border Width**: `2px`
- **Palette**: Dark Gruvbox (`#282828`, `#3c3836`) and Beige (`#ebdbb2`, `#C9B8A0`, `#faebd7`)

## Dependencies

### Core

| Package | Purpose |
|---|---|
| `hyprland` | Window manager |
| `waybar` | Status bar |
| `wofi` | App launcher & power menu |
| `dunst` | Notifications (OSD for volume/brightness) |
| `alacritty` | Terminal emulator |
| `zsh` | Shell |
| `neovim` | Editor |

### Hyprland Ecosystem

| Package | Purpose |
|---|---|
| `hyprpaper` | Wallpaper |
| `hyprlock` | Lock screen |
| `hypridle` | Idle daemon (auto-lock, screen off) |
| `hyprpolkitagent` | Polkit authentication agent |

### Utilities

| Package | Purpose |
|---|---|
| `grimblast-git` | Screenshots (`Super + S` / `Super + Shift + S`) |
| `cliphist` | Clipboard history (`Super + C`) |
| `wl-clipboard` | Wayland clipboard (`wl-copy`, `wl-paste`) |
| `brightnessctl` | Brightness control (laptop) |
| `playerctl` | Media key support |
| `thunar` | File manager |
| `stow` | Dotfile symlink manager |

### System Tray / GUI Utilities

| Package | Purpose |
|---|---|
| `pavucontrol` | Volume control (click Waybar volume) |
| `blueman` | Bluetooth manager (click Waybar BT) |
| `nm-connection-editor` | WiFi/Network manager (click Waybar WiFi) |
| `networkmanager` | Network backend |

### Fonts & Cursors

| Package | Purpose |
|---|---|
| `ttf-roboto-mono` | UI font |
| `ttf-font-awesome` | Icon font |
| `bibata-cursor-theme-bin` | Cursor theme (`Bibata-Modern-Ice`) |

## Installation

### Automatic

```bash
git clone https://github.com/<your-user>/dotfiles.git ~/dotfiles
cd ~/dotfiles
./setup.sh
```

The script will:
- Install all packages (pacman + AUR)
- Stow the configs into `$HOME`
- Ask if you have an NVIDIA GPU and configure `env.conf` accordingly
- Create an empty `secret.conf` for private keybinds
- Enable NetworkManager and Bluetooth services
- Set script permissions

### Manual

1. **Install dependencies** (Arch):
   ```bash
   # Core + Hyprland ecosystem
   sudo pacman -S --needed hyprland waybar wofi dunst alacritty zsh neovim \
     hyprpaper hyprlock hypridle \
     wl-clipboard brightnessctl playerctl thunar stow \
     pavucontrol blueman nm-connection-editor networkmanager \
     ttf-roboto-mono ttf-font-awesome pipewire wireplumber

   # AUR packages (via yay/paru)
   yay -S --needed grimblast-git cliphist hyprpolkitagent bibata-cursor-theme-bin
   ```

2. **Clone and stow**:
   ```bash
   git clone https://github.com/<your-user>/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   stow base
   ```

3. **Configure environment variables**:
   ```bash
   # For NVIDIA:
   # Edit env.conf directly (already contains NVIDIA vars)

   # For AMD/Intel:
   cp ~/.config/hypr/conf.d/env.conf.example ~/.config/hypr/conf.d/env.conf
   ```

4. **Create secrets file**:
   ```bash
   touch ~/.config/hypr/conf.d/secret.conf
   ```

5. **Start Hyprland**:
   ```bash
   Hyprland
   ```

## Secrets Management

Sensitive information (like SSH commands with hardcoded passwords) is omitted from this repository. 

To use those keybinds locally:
1. Create a file at `base/.config/hypr/conf.d/secret.conf`
2. Define your private binds there (e.g., `bind = $mainMod, T, exec, ...`)
3. The `.gitignore` ensures this file is never committed.

## Keybinds

| Key | Action |
|---|---|
| `Super + Return` | Terminal (Alacritty) |
| `Super + D` | App launcher (Wofi) |
| `Super + W` | Close window |
| `Super + M` | Power menu |
| `Super + L` | Lock screen |
| `Super + S` | Screenshot (region) |
| `Super + Shift + S` | Screenshot (full screen) |
| `Super + C` | Clipboard history |
| `Super + V` | Toggle floating |
| `Super + F` | Fullscreen |
| `Super + R` | Reload Hyprland + Waybar |
| `Super + E` | File manager |
| `Super + 1-5, 9` | Switch workspace |
| `Super + Shift + 1-5, 9` | Move window to workspace |
