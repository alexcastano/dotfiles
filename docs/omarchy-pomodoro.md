# Pomodoro Shell Plugin

User-owned Omarchy shell plugin (`alex.pomodoro`) implementing the Pomodoro
technique. Lives in the `omarchy` stow package at
`~/.config/omarchy/plugins/alex.pomodoro/` (symlinked from `~/.dotfiles/omarchy/`).

## Architecture

Two kinds, one shared state object:

- `Service.qml` — singleton clock. Owns phase, countdown, session count, and
  fires the end-of-phase notification (once per session, not per monitor).
- `BarWidget.qml` — bar face. Reads state via `bar.shell.serviceFor("alex.pomodoro")`
  and pushes its `shell.json` layout settings into the service.
- `Pomodoro.js` — pure logic (phase transitions, clock formatting). Glyphs:
  `󱎫` focus (md-timer), `󰅶` break (md-coffee).

## Controls

- Bar: left click = popup, right click = start/pause, middle click = reset.
- Popup: start/pause, reset, skip buttons; dots show progress toward the long break.
- Phase end: `omarchy-notification-send` with the phase glyph.

## IPC

```bash
omarchy-shell alex.pomodoro status   # "Focus 24:58 running (completed: 3)"
omarchy-shell alex.pomodoro toggle   # start/pause
omarchy-shell alex.pomodoro start
omarchy-shell alex.pomodoro pause
omarchy-shell alex.pomodoro reset
omarchy-shell alex.pomodoro skip     # ends current phase early, counts it
```

Bind in `~/.config/hypr/bindings.lua`, e.g.:
`hl.bind("...", "SUPER,p", "exec", "omarchy-shell alex.pomodoro toggle")`.

## Settings

Inline in the `alex.pomodoro` entry of the bar layout in
`~/.config/omarchy/shell.json` (hot-reloads on save):

| Key | Default | Meaning |
|-----|---------|---------|
| `focusMinutes` | 25 | Focus length |
| `shortBreakMinutes` | 5 | Short break length |
| `longBreakMinutes` | 15 | Long break length |
| `longBreakInterval` | 4 | Focus sessions per long break |
| `autoStartBreaks` | true | Break starts automatically |
| `autoStartFocus` | false | Focus starts automatically after a break |
| `notify` | true | Send notification on phase end |

## Reload

Saving any file under `~/.config/omarchy/plugins/` hot-reloads plugin code.
After adding/removing the plugin or changing its manifest:
`omarchy-shell shell rescanPlugins`.
