# Migración a Omarchy quattro (4.0.0.alpha)

Rama: `quattro`. Punto de partida: commit `b0754f6` (snapshot del working tree
tal como quedó tras `omarchy-upgrade-to-quattro`, 2026-08-22).
`master` = último estado bueno de Omarchy 3 (rollback).

## Qué cambió en quattro

| Área | Omarchy 3 | Omarchy quattro |
|---|---|---|
| Instalación | git clone en `~/.local/share/omarchy` | paquete pacman en `/usr/share/omarchy` (symlink de compat) |
| Config Hyprland | `hyprland.conf` + `source =` | **`hyprland.lua`** (`hyprctl systeminfo` → `configProvider: lua`) |
| Estado | `~/.config/omarchy/current` | `~/.local/state/omarchy/current` |
| Barra | waybar | `omarchy-shell` (waybar desinstalado) |
| Notificaciones | mako | omarchy-shell (mako desinstalado) |
| OSD volumen/brillo | swayosd | omarchy-shell (swayosd desinstalado) |
| Lanzador | walker | omarchy-shell (**walker desinstalado**) |
| Idle / lock | hypridle + hyprlock | nativo omarchy (`omarchy-system-lock`, `omarchy-toggle-idle`); **paquetes desinstalados** |
| Config barra | `~/.config/waybar/` | `~/.config/omarchy/shell.json` |

La migración dejó backups con sufijo `.omarchy-upgrade-to-quattro.20260822185803.bak`
(listar: `find ~/.config ~/.local/share -maxdepth 2 -name '*omarchy-upgrade-to-quattro*'`).

## API Lua nueva

`~/.config/hypr/hyprland.lua` carga `bootstrap.lua` (que pone `~/.config` en
`package.path`), luego `require("default.hypr.omarchy")`, luego los módulos
propios (`require("hypr.monitors")` etc.).

Dos globales: `hl` (API de Hyprland) y `o` (helpers de Omarchy).

- Stubs / autocompletado: `/usr/share/hypr/stubs/hl.meta.lua` (ya referenciado
  desde `.luarc.json`).
- Helpers de Omarchy: `/usr/share/omarchy/default/hypr/helpers.lua`.

| Sintaxis `.conf` | Equivalente Lua |
|---|---|
| `monitor = ...` | `hl.monitor({ output=, mode=, position=, scale=, transform= })` |
| `env = K,V` | `hl.env("K", "V")` |
| `input { ... }`, `general { ... }` | `hl.config({ input = { ... } })` |
| `device { name = ... }` | `hl.device({ ... })` |
| `bindd = MOD, KEY, Desc, exec, cmd` | `o.bind("SUPER + KEY", "Desc", "cmd")` |
| `binddr` (al soltar) | `hl.bind(keys, dsp, { release = true })` |
| `unbind = MOD, KEY` | `hl.unbind("SUPER + KEY")` |
| `windowrule = X, match:class C` | `o.window("C", { ... })` |
| `exec-once = uwsm-app -- cmd` | `o.launch_on_start("cmd")` |
| `exec-once = cmd` (sin uwsm) | `o.exec_on_start("cmd")` |
| `submap = name` | `hl.define_submap(name, reset_or_fn, fn)` |
| `gesture = ...` | `hl.gesture({ fingers=, direction=, action= })` |

## Checklist

### 1. Hyprland: `.conf` → `.lua`  ← BLOQUEANTE

Nada de la config propia se aplica: Hyprland lee `hyprland.lua` y los `.lua`
que dejó la migración son plantillas vacías (todo comentado). Los `.conf` siguen
en el repo pero se ignoran.

- [ ] `monitors.conf` → `monitors.lua`: `GDK_SCALE=1`, default `preferred/auto/1`,
      override LG UltraGear por descripción a 1440p@120 (temporal: rayas negras
      a 4K por HDMI), ARZOPA `auto-left`.
- [ ] `input.conf` → `input.lua`: `kb_layout=us,es`, `kb_options=ctrl:nocaps`,
      `repeat_rate=40`, `repeat_delay=600`, `numlock_by_default`,
      `touchpad.scroll_factor=0.4`, `scroll_touchpad` por app (terminales),
      device `tpps/2-elan-trackpoint` (`sensitivity=-0.5`, accel adaptive).
      Ojo: la regla de `Waybar` sobra (waybar ya no existe).
- [ ] `bindings.conf` → `bindings.lua`: ~50 bindings. Revisar comandos muertos:
      - `omarchy-launch-walker` (SUPER+D) → walker desinstalado, usar omarchy-shell.
      - `omarchy-menu-keybindings` sigue existiendo (SUPER+SHIFT+/).
      - dictado voxtype: `binddr` → `{ release = true }`.
- [ ] `looknfeel.conf` → `looknfeel.lua`: solo `decoration.rounding = 8`.
- [ ] `autostart.conf` → `autostart.lua`: `hyprsunset`, `eww daemon` +
      `which-key-daemon.sh`, `scripts/screencast-dnd`.
- [ ] `windowrules.conf` → reglas `o.window(...)`: asignaciones de workspace
      (Spotify 10, slack/ferdium/WhatsApp 9, teams 8, zen 5, telegram 3).
- [ ] `submaps.conf` + `submaps/*.conf` → `hl.define_submap(...)`.
- [ ] Borrar lo muerto: `hyprland.conf`, `hypridle.conf`, `hyprlock.conf`
      (hypridle y hyprlock ya no están instalados).

### 2. Barra: waybar → omarchy-shell
- [ ] Decidir: portar módulos propios de `hyprland/.config/waybar/` a
      `~/.config/omarchy/shell.json`, o adoptar los defaults de omarchy-shell.
- [ ] `hyprland/.config/waybar/` en el repo: portar y borrar, o dejar de stowear.

### 3. which-key (eww)
`eww` sigue instalado. `which-key-daemon.sh` escucha el evento `submap` del
socket IPC y parsea `hyprctl binds` — ambos siguen existiendo en quattro.
- [ ] Depende de (1): redefinir submaps en Lua y volver a arrancar el daemon.
- [ ] Comprobar que `o.bind(..., description, ...)` sigue exponiendo
      `description` en `hyprctl binds` (el daemon filtra por eso).
- [ ] Alternativa más limpia que socat: `hl.on("keybinds.submap", cb)`.
- [ ] El tema ya no expone `swayosd.css` (de donde `docs/which-key.md` saca el
      color del borde). Buscar el equivalente en el tema de quattro.
- [ ] `submaps/notifications.conf` usa `makoctl` (dismiss/invoke/restore) →
      reescribir con `omarchy-notification-dismiss` /
      `omarchy-toggle-notification-silencing`.

### 4. Scripts propios roto por herramientas desinstaladas
- [ ] `hypr/scripts/keyboard-layout-osd`: `swayosd-client` → `omarchy-osd`.
- [ ] `hypr/scripts/screencast-dnd`: `makoctl mode` → equivalente en
      omarchy-shell.
- [ ] `bin/.local/bin/dnd-toggle`: revisar, probablemente envuelve mako →
      `omarchy-toggle-notification-silencing`.

### 5. Webapps
La migración regeneró los 3 lanzadores preinstalados (WhatsApp, YouTube,
Google Photos) y se perdió `env WEBAPP_CONTEXT=Personal` (integración
open-in-zen) y los iconos propios (`~/.local/share/applications/icons` → `.bak`).
Los webapps creados por el usuario (ChatGPT, GitHub, Outlook…) están intactos.
- [ ] Restaurar `WEBAPP_CONTEXT` + iconos en los 3 lanzadores.
- [ ] Revisar `install-webapps.sh` contra el nuevo `omarchy-webapp-install`.

### 6. Barra: waybar → omarchy-shell
- [ ] Decidir: portar los módulos propios de `hyprland/.config/waybar/` a
      `~/.config/omarchy/shell.json`, o adoptar los defaults de omarchy-shell.
- [ ] Según la decisión: portar y borrar `hyprland/.config/waybar/`, o dejar de
      stowearlo.

### 7. Idle / lock
- [ ] Reproducir lo que hacían `hypridle.conf` / `hyprlock.conf` con
      `omarchy-settings` / `shell.json` / `omarchy-toggle-idle`.

### 8. Instaladores y documentación del repo
- [ ] `install-hyprland.sh`: instala `hypridle`, `hyprlock`, `waybar`, `mako`,
      `swayosd-git`, y clona omarchy a mano. Todo obsoleto en quattro.
- [ ] `docs/hyprland.md`: describe la arquitectura de Omarchy 3 (waybar, mako,
      rutas `~/.local/share/omarchy` y `~/.config/omarchy/current`).
- [ ] `docs/which-key.md`: rutas de tema y `swayosd.css`.

### 9. Backups sueltos por revisar
Ninguno estaba en el repo (los gestionaba omarchy), pero conviene diffear por si
había algo propio: `chromium-flags.conf`, `brave-flags.conf`, `mimeapps.list`,
`xdg-terminals.list`, `uwsm/env`, `uwsm/default`, `environment.d/fcitx.conf`,
`fastfetch`, `fontconfig/fonts.conf`, `imv`, `xournalpp`.

### 10. Verificar (sin problema conocido)
- [ ] nvim: quattro trae paquete `omarchy-nvim`; el repo stowea su propio
      LazyVim en `vim/.config/nvim`. Comprobar que no colisionan.
- [ ] `hyprsunset.conf` y `xdph.conf`: siguen siendo `.conf` en quattro, OK.
