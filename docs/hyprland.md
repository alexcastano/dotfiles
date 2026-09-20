# Hyprland / Omarchy (quattro)

Omarchy es una capa de configuración sobre Hyprland: trae los defaults y el
tema, y lo propio vive aparte. Desde Omarchy 4 (quattro) **la configuración es
Lua**, no `.conf` — `hyprctl systeminfo` lo confirma (`configProvider: lua`).

La migración desde Omarchy 3 está documentada entrada por entrada en
[omarchy-quattro-migration.md](omarchy-quattro-migration.md), que es donde mirar
el *por qué* de cualquier decisión de esta config.

## Las tres capas

| Capa | Ruta | Regla |
|---|---|---|
| Defaults de Omarchy | `/usr/share/omarchy/default/` | **No tocar**: es un paquete pacman, se sobrescribe en cada update |
| Tema actual | `~/.local/state/omarchy/current/theme` | Generado. Ojo: en Omarchy 3 esto vivía en `~/.config/omarchy/current` |
| Config propia | `~/.config/hypr/` → **symlink al repo** | Se carga *después* de los defaults, así que gana |

Como `~/.config/hypr` es un symlink al directorio del repo, **borrar un fichero
del repo lo quita de la config viva al instante**, sin pasar por stow.

`~/.config/omarchy/` (hooks, `shell.json` — toda la config de la barra) **no
está versionado** todavía: ver REP-12 en el documento de migración.

## Cómo carga

`hyprland.lua` es el entrypoint. Hace `bootstrap.lua` (mete `~/.config` en
`package.path`), luego `require("default.hypr.omarchy")` (todos los defaults), y
después los módulos propios:

| Módulo | Contenido |
|---|---|
| `monitors.lua` | Plantilla de quattro sin cambios (`preferred/auto/1`) |
| `input.lua` | Teclado `us`+`altgr-intl` con Caps=Ctrl, y el gesto de 3 dedos |
| `bindings.lua` | Solo dos excepciones: dictado en `SUPER+SPACE` y `SUPER+N` |
| `looknfeel.lua` | Vacío: todo al default |
| `autostart.lua` | `screencast-dnd` |
| `windowrules.lua` | Apps fijadas a su escritorio (Spotify→10, Slack→9…) |

Dos globales en cualquiera de ellos: **`hl`** (API de Hyprland) y **`o`**
(helpers de Omarchy, en `/usr/share/omarchy/default/hypr/helpers.lua`).
Los tipos para el editor salen de `/usr/share/hypr/stubs/hl.meta.lua`, que es a
lo que apunta `.luarc.json`.

Quedan dos `.conf` en el paquete, y **ninguno es de Hyprland**:
`hyprsunset.conf` (lo lee `nightlight-toggle`) y `xdph.conf` (lo lee el portal
de screencast; es copia exacta del default de quattro).

## Bindings

Regla del repo: **lo más estándar posible**. Un binding propio hay que revisarlo
en cada upgrade y puede chocar con un default nuevo, así que solo se justifica
si el default no existe. Hoy hay exactamente dos excepciones, las dos razonadas
en el comentario de `bindings.lua`.

```bash
omarchy menu keybindings --print   # los bindings activos, con descripción
```

**No sirve `hyprctl binds`**: con config Lua todos los bindings salen como
`dispatcher: __lua, arg: N`, sin el comando. Las descripciones sí sobreviven.
Por eso se borró el script propio `hyprkeys`: la información ya no existe.

## Voxtype

Corre como servicio de usuario y transcribe contra el `whisper.cpp` remoto de
`powerant:8080` (el servidor vive en el repo `homelab`).

- Config: `~/.config/voxtype/config.toml` (versionada en `hyprland/.config/voxtype/`)
- Post-proceso: `bin/.local/bin/voxtype-clean-transcript` junta las líneas que
  `whisper.cpp` mete por segmento — si no, el texto envía el mensaje a medias en
  un chat y ejecuta la línea en una terminal.
- Driver de tecleado: `driver_order = ["dotool", "wtype", "clipboard"]`.
  **dotool va primero a propósito.** `wtype` sube un keymap sintético por el
  protocolo virtual-keyboard y Electron no lo respeta, así que los acentos
  desaparecen en Slack mientras en la terminal salen bien
  ([electron#46823](https://github.com/electron/electron/issues/46823), cerrado
  como *not planned*). dotool escribe keycodes evdev reales por `/dev/uinput` y
  Electron lo trata como teclado físico.
- **dotool necesita el grupo `input`.** Su regla udev deja `/dev/uinput` en
  `root:input 0620`, así que una máquina nueva necesita
  `sudo usermod -aG input $USER` **y volver a iniciar sesión** (el servicio de
  usuario hereda los grupos de la sesión). Sin eso dotool cae a `wtype` y el
  dictado sigue escribiendo, solo que con los acentos rotos en Electron.
  El precio: `input` da lectura de todos los dispositivos de entrada.
- dotool no lee el layout activo del compositor: `dotool_xkb_layout` y
  `dotool_xkb_variant` tienen que seguir a `input.lua` (`us` / `altgr-intl`).

## DND al compartir pantalla

`~/.config/hypr/scripts/screencast-dnd` silencia las notificaciones mientras
compartes pantalla. No hay equivalente de serie en quattro.

- Escucha en DBus los eventos de `org.freedesktop.portal.ScreenCast`
- Activa y desactiva con `omarchy-shell notifications setDnd on|off`, y consulta
  con `dndState` (el `makoctl` + `dnd-toggle` de Omarchy 3 ya no existen)
- **Respeta el DND manual**: el fichero de estado marca "lo encendí yo", así que
  si ya lo tenías puesto ni lo toca ni lo apaga al terminar
- Lo arranca `autostart.lua` con `o.launch_on_start` (o sea uwsm-app), para que
  systemd lo recoja al cerrar sesión

## Estructura del paquete stow

```
hyprland/
├── .local/bin/nightlight-toggle      # toggle de luz nocturna a la temperatura de hyprsunset.conf
└── .config/
    ├── hypr/
    │   ├── hyprland.lua              # entrypoint
    │   ├── monitors.lua  input.lua  bindings.lua
    │   ├── looknfeel.lua  autostart.lua  windowrules.lua
    │   ├── hyprsunset.conf  xdph.conf
    │   ├── .luarc.json               # stubs de tipos para el editor
    │   └── scripts/screencast-dnd
    └── voxtype/config.toml
```

## Comandos útiles

```bash
hyprctl reload                     # recargar la config
hyprctl configerrors               # ver si la recarga se quejó
hyprctl monitors                   # monitores y modos
omarchy menu keybindings --print   # bindings activos
omarchy theme <nombre>             # cambiar de tema
```

## Hooks de Omarchy

En `~/.config/omarchy/hooks/`, con `.d/` por evento: `theme-set`, `font-set`,
`post-update`, `post-boot`, `battery-low`, `pre-refresh-pacman`. Se crean
quitando la extensión `.sample` de los ejemplos.

**Este directorio no está versionado** (REP-12). Ya costó una deriva silenciosa:
un `theme-set` con un `eww reload` dentro sobrevivió 8 meses fuera del repo.
