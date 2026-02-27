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

## Secrets Management

Sensitive information (like SSH commands with hardcoded passwords) is omitted from this repository. 

To use those keybinds locally:
1. Create a file at `base/.config/hypr/conf.d/secret.conf`
2. Define your private binds there (e.g., `bind = $mainMod, T, exec, ...`)
3. The `.gitignore` ensures this file is never committed.

## Installation

*(Stow or symlink instructions can be added here depending on your preferred dotfile manager!)*
