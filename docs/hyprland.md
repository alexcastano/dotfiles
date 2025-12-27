# Hyprland Configuration (Omarchy)

## Architecture Overview

This system uses **Omarchy** as a configuration layer on top of Hyprland. Omarchy manages defaults and theming, while user customizations are kept separate.

## Configuration Layers

### 1. Omarchy Defaults (DO NOT EDIT)
Location: `~/.local/share/omarchy/default/`

Contains default configurations for:
- `hypr/` - Hyprland bindings, autostart, environment, input, windows
- `waybar/` - Status bar configuration
- `mako/` - Notification daemon
- `alacritty/`, `ghostty/`, `kitty/` - Terminal emulators
- And more...

### 2. Omarchy Themes
Location: `~/.config/omarchy/themes/`

Each theme provides styling overrides:
- `waybar.css` - Status bar styling
- `mako.ini` - Notification colors
- `hyprland.conf` - Visual settings
- `hyprlock.conf` - Lock screen styling
- `alacritty.toml`, `ghostty.conf`, etc.

Current theme symlinked at: `~/.config/omarchy/current/theme`

### 3. User Overrides (TRACK THESE IN DOTFILES)
Location: `~/.config/hypr/`

These files are sourced AFTER omarchy defaults, so they override settings:

| File | Purpose |
|------|---------|
| `hyprland.conf` | Main config - sources everything else |
| `monitors.conf` | Monitor layout and resolution |
| `input.conf` | Keyboard, mouse, touchpad settings |
| `bindings.conf` | Custom keybindings |
| `looknfeel.conf` | Visual tweaks (gaps, borders, animations) |
| `autostart.conf` | Startup applications |

## Omarchy Customization Philosophy

Omarchy maintains a clear separation between user and system files:
- **User customizations**: `~/.config/` - yours to modify freely
- **Omarchy internals**: `~/.local/share/omarchy/` - DO NOT edit

Omarchy provides initial configs in `~/.config/` but you own them. Edits persist through updates.

**Quick edit**: Use Omarchy menu (Super + Alt + Space) → Setup → Configs. Processes auto-restart after saving.

**Reference**: https://learn.omacom.io/2/the-omarchy-manual/65/dotfiles

## What to Track in Dotfiles

**Include in `hyprland/` stow package:**
- `~/.config/hypr/*.conf` - Hyprland user override files
- `~/.config/waybar/config.jsonc` - Status bar config (if customized)
- `~/.config/mako/config` - Notifications (if customized)

**Do NOT include:**
- `~/.config/waybar/style.css` - Symlinked to current theme
- `~/.config/omarchy/` - Omarchy's own management folder
- `~/.local/share/omarchy/` - Omarchy system files

## Stow Package Structure

```
hyprland/
└── .config/
    ├── hypr/
    │   ├── hyprland.conf
    │   ├── monitors.conf
    │   ├── input.conf
    │   ├── bindings.conf
    │   ├── looknfeel.conf
    │   └── autostart.conf
    └── waybar/
        └── config.jsonc      # (optional, if customized)
```

## Useful Commands

```bash
# Reload Hyprland config
hyprctl reload

# Check current monitors
hyprctl monitors

# List keybindings
hyprctl binds

# Switch Omarchy theme
omarchy theme <theme-name>
```

## Source Order in hyprland.conf

1. Omarchy defaults from `~/.local/share/omarchy/default/hypr/`
2. Current theme from `~/.config/omarchy/current/theme/hyprland.conf`
3. User overrides from `~/.config/hypr/*.conf`

This means user settings always win.
