# Which-Key for Hyprland Submaps

A vim-style which-key implementation for Hyprland that displays available keybindings when entering a submap. Uses eww widgets with dynamic theme colors from Omarchy.

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     Hyprland                                │
│  ┌─────────────┐    IPC Events    ┌─────────────────────┐  │
│  │   Submap    │ ────────────────▶│ which-key-daemon.sh │  │
│  │  (Super+B)  │   "submap>>name" │                     │  │
│  └─────────────┘                  └──────────┬──────────┘  │
│                                              │              │
│                                              ▼              │
│                                   ┌─────────────────────┐  │
│                                   │    eww daemon       │  │
│                                   │  ┌───────────────┐  │  │
│                                   │  │  which-key    │  │  │
│                                   │  │   widget      │  │  │
│                                   │  └───────────────┘  │  │
│                                   └─────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
              ┌───────────────────────────┐
              │  Omarchy Theme            │
              │  ~/.config/omarchy/       │
              │  current/theme/swayosd.css│
              └───────────────────────────┘
```

## How It Works

1. **Submap Entry**: User presses `Super+B` to enter bluetooth submap
2. **IPC Event**: Hyprland emits `submap>>bluetooth` via socket2
3. **Daemon Listens**: `which-key-daemon.sh` receives the event via socat
4. **Fetch Bindings**: Daemon queries `hyprctl binds -j` for submap keybindings
5. **Update Widget**: Daemon sends bindings to eww, opens which-key window
6. **Submap Exit**: When submap resets, daemon closes the widget

## Files

### Dotfiles (`~/.dotfiles/hyprland/.config/`)

| File | Purpose |
|------|---------|
| `eww/eww.yuck` | Widget definition with dynamic theme colors |
| `eww/eww.scss` | Structural styles (padding, fonts, layout) |
| `eww/which-key-daemon.sh` | Hyprland IPC listener daemon |
| `hypr/submaps.conf` | Sources all submap configurations |
| `hypr/submaps/bluetooth.conf` | Example submap with `bindd` descriptions |
| `hypr/autostart.conf` | Starts eww daemon and which-key-daemon |

### Omarchy Hooks (`~/.config/omarchy/hooks/`)

| File | Purpose |
|------|---------|
| `theme-set` | Reloads eww when theme changes |

## Creating a New Submap

1. Create `~/.dotfiles/hyprland/.config/hypr/submaps/<name>.conf`:

```hyprland
# Example: ~/.config/hypr/submaps/resize.conf
bind = SUPER, R, submap, resize

submap = resize
    bindd = , H, Grow width, resizeactive, 50 0
    bindd = , L, Shrink width, resizeactive, -50 0
    bindd = , J, Grow height, resizeactive, 0 50
    bindd = , K, Shrink height, resizeactive, 0 -50

    bindd = , ESCAPE, Cancel, submap, reset
    bindd = , RETURN, Cancel, submap, reset
submap = reset
```

2. Add to `submaps.conf`:
```hyprland
source = ~/.config/hypr/submaps/resize.conf
```

3. Reload Hyprland: `hyprctl reload`

**Key points:**
- Use `bindd` (with description) instead of `bind` for which-key to display hints
- ESCAPE and RETURN are automatically hidden from the popup
- Bindings are sorted alphabetically by key

## Dynamic Theme Integration

Colors are read from Omarchy theme at runtime via `defpoll`:

```yuck
(defpoll theme_border :interval "1h"
  `grep 'border-color' ~/.config/omarchy/current/theme/swayosd.css | grep -oE '#[0-9a-fA-F]+'`)
```

When theme changes:
1. Omarchy updates symlinks in `~/.config/omarchy/current/theme/`
2. `theme-set` hook runs `eww reload`
3. eww re-polls colors from new theme files

## Dependencies

- `eww` - ElKowar's Wacky Widgets
- `socat` - For Hyprland IPC socket communication
- `jq` - JSON parsing for hyprctl output

## Troubleshooting

**Widget not appearing:**
```bash
# Check daemon is running
pgrep -f which-key-daemon

# Start manually
~/.config/eww/which-key-daemon.sh &

# Check eww daemon
eww ping
```

**Wrong colors:**
```bash
# Force eww reload
eww reload

# Check current theme colors
cat ~/.config/omarchy/current/theme/swayosd.css
```

**Bindings not showing:**
```bash
# Verify bindings have descriptions
hyprctl binds -j | jq '[.[] | select(.submap == "bluetooth" and .has_description == true)]'
```

## Future Improvements

- [ ] Add icons per submap (bluetooth icon, resize icon, etc.)
- [ ] Support nested submaps
- [ ] Add timeout to auto-close widget
- [ ] Animate widget appearance
