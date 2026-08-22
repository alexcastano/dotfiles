# Migración a Omarchy quattro — inventario completo

> Documento de trabajo. Se va tachando sesión a sesión. **No es un plan de
> migración rápida**: es una lista para revisar entrada por entrada.

- **Rama**: `quattro`
- **Punto de partida**: commit `b0754f6` — snapshot del working tree tal como
  quedó tras `omarchy-upgrade-to-quattro` (2026-08-22)
- **Rollback**: `master` = último estado bueno de Omarchy 3
- **Versiones**: Omarchy 4.0.0.alpha, Hyprland 0.56.2

---

## Cómo trabajamos

El objetivo **no** es que vuelva a funcionar lo antes posible. El objetivo es
**entender qué tenía, por qué lo tenía, y decidir con criterio** si lo sigo
queriendo. Omarchy 4 trae muchísimo más de serie que Omarchy 3: buena parte de
lo que había en esta config eran parches para cosas que ahora vienen resueltas.
Migrar a ciegas significaría arrastrar deuda durante años.

**Reglas de la migración:**

1. **Una entrada a la vez.** Se coge una fila de la lista, se entiende y se
   decide. No se toca nada "de paso".
2. **Antes de decidir, entender.** Para cada entrada hay que poder responder:
   ¿qué hacía exactamente? ¿por qué lo puse? ¿sigue existiendo el problema que
   resolvía?
3. **Por defecto, adaptarse a lo nuevo.** Si Omarchy 4 ya lo hace de serie,
   la opción preferente es borrar lo propio y aprender la forma nueva, aunque
   incomode al principio. Solo se mantiene una personalización si hay una razón
   concreta que sobreviva al escrutinio.
4. **Nada de traducción mecánica.** Que una línea `.conf` tenga equivalente
   Lua exacto no es razón para migrarla.
5. **Commits pequeños**, uno por entrada o por grupo coherente, con el
   razonamiento en el mensaje.
6. **Se registra la decisión**, también cuando es "borrar". El *por qué* de un
   borrado es tan útil como el de un cambio (ver [Registro de decisiones](#registro-de-decisiones)).
7. **Sin prisa.** Si una entrada necesita probar el comportamiento nuevo unos
   días antes de decidir, se deja en 🔍 y se pasa a la siguiente.

**Estados**: ⬜ pendiente · 🔍 en pruebas / decisión aplazada · ✅ hecho · ⏭️ descartado (decidido no migrar)

**Flujo de cada sesión**: elegir un bloque → repasar sus entradas una a una →
decidir → aplicar → `hyprctl reload` y probar → commit → actualizar estados y
el registro de decisiones en este fichero.

---

## Qué cambió en quattro

| Área | Omarchy 3 | Omarchy quattro |
|---|---|---|
| Instalación | git clone en `~/.local/share/omarchy` | paquete pacman en `/usr/share/omarchy` (symlink de compat) |
| Config Hyprland | `hyprland.conf` + `source =` | **`hyprland.lua`** (`hyprctl systeminfo` → `configProvider: lua`) |
| Estado | `~/.config/omarchy/current` | `~/.local/state/omarchy/current` |
| Barra | waybar | `omarchy-shell` (waybar desinstalado) |
| Notificaciones | mako | omarchy-shell (mako desinstalado) |
| OSD volumen/brillo | swayosd | `omarchy-osd` (swayosd desinstalado) |
| Lanzador | walker | `omarchy-menu` (walker desinstalado) |
| Idle / lock | hypridle + hyprlock | nativo; config en `~/.config/omarchy/shell.json` |
| Config barra | `~/.config/waybar/config.jsonc` | `~/.config/omarchy/shell.json` |
| Control multimedia | `playerctl` | `omarchy-shell media …` (playerctl desinstalado) |

**Comandos que usaba y ya no existen**: `omarchy-launch-walker`, `playerctl`,
`makoctl`, `swayosd-client`, `hyprlock`, `hypridle`, `omarchy-launch-wifi`,
`omarchy-launch-bluetooth`, `omarchy-launch-audio`, `omarchy-tz-select`, `typora`.

**Ojo**: `~/.config/hypr` es un symlink a este repo, así que la migración de
Omarchy **escribió dentro del repo**. Los `.lua` nuevos y el cambio de ruta del
tema en `hyprland.conf` los hizo ella, no yo.

Backups de la migración:
`find ~/.config ~/.local/share -maxdepth 2 -name '*omarchy-upgrade-to-quattro*'`

---

## Referencia: la API Lua nueva

`~/.config/hypr/hyprland.lua` carga `bootstrap.lua` (mete `~/.config` en
`package.path`), luego `require("default.hypr.omarchy")` (los defaults), y luego
los módulos propios: `require("hypr.monitors")`, `hypr.input`, `hypr.bindings`,
`hypr.looknfeel`, `hypr.autostart`.

Dos globales: **`hl`** (API de Hyprland) y **`o`** (helpers de Omarchy).

- Stubs para autocompletado: `/usr/share/hypr/stubs/hl.meta.lua` (ya apuntado desde `.luarc.json`)
- Helpers de Omarchy: `/usr/share/omarchy/default/hypr/helpers.lua`
- Defaults que se cargan antes de lo mío: `/usr/share/omarchy/default/hypr/`

| Sintaxis `.conf` | Equivalente Lua |
|---|---|
| `monitor = ...` | `hl.monitor({ output=, mode=, position=, scale=, transform= })` |
| `env = K,V` | `hl.env("K", "V")` |
| `input { ... }` / `general { ... }` | `hl.config({ input = { ... } })` |
| `device { name = ... }` | `hl.device({ ... })` |
| `bindd = MOD, KEY, Desc, exec, cmd` | `o.bind("SUPER + KEY", "Desc", "cmd")` |
| `binddr` (al soltar) | `o.bind(keys, desc, cmd, { release = true })` |
| `bind` con `repeat` / durante lock | `{ repeating = true }` / `{ locked = true }` |
| `unbind = MOD, KEY` | `hl.unbind("SUPER + KEY")` |
| `windowrule = X, match:class C` | `o.window("C", { ... })` |
| `exec-once = uwsm-app -- cmd` | `o.launch_on_start("cmd")` |
| `exec-once = cmd` | `o.exec_on_start("cmd")` |
| `submap = name` | `hl.define_submap(name, reset_or_fn, fn)` |
| `gesture = ...` | `hl.gesture({ fingers=, direction=, action= })` |
| dispatcher `exec` | `hl.dsp.exec_cmd(cmd)` |
| dispatchers nativos | `hl.dsp.focus{}`, `hl.dsp.window.close()`, `hl.dsp.workspace.*`… |

Azúcar de Omarchy para lanzar cosas (en vez de escribir el comando a mano):
`{ omarchy = "browser" }`, `{ webapp = "https://…", focus = true }`,
`{ tui = "btop", focus = true }`, `{ launch = "obsidian", focus = "^obsidian$" }`.

---

# LA LISTA

## A. Monitores — `monitors.conf` → `monitors.lua`

| St. | ID | Qué tengo | Qué hacía | En quattro | A decidir |
|---|---|---|---|---|---|
| ⬜ | MON-1 | `env = GDK_SCALE,1` | Escalado GTK a 1 | La plantilla nueva ya trae `hl.env("GDK_SCALE", ...)` con variable local | ¿Sigo en escala 1 o pruebo el escalado nuevo de Omarchy 4 (tiene panel `omarchy.monitor` y `SUPER+CTRL+D`)? |
| ⬜ | MON-2 | `monitor=,preferred,auto,1` | Default para cualquier monitor | Idéntico en la plantilla nueva | Probablemente sin cambios. Confirmar. |
| ⬜ | MON-3 | `monitor=desc:LG …ULTRAGEAR+ 401NTQD3N604,2560x1440@120,auto,1` | **Workaround temporal**: a 4K por HDMI salen rayas negras (fallo del panel/enlace, aparece incluso en el OSD del monitor) | El workaround no depende de Omarchy, sigue aplicando | ¿Ya llegó el hub USB-C → DisplayPort? Si sí, probar 4K@1.25 otra vez y quitar esto. Si no, migrar el override tal cual. |
| ⬜ | MON-4 | `monitor=desc:GWD ARZOPA,preferred,auto-left,1` | Monitor portátil siempre a la izquierda del portátil | Sigue aplicando | Migrar. Comprobar que `position = "auto-left"` funciona igual en `hl.monitor{}`. |

## B. Input — `input.conf` → `input.lua`

| St. | ID | Qué tengo | Qué hacía | En quattro | A decidir |
|---|---|---|---|---|---|
| ⬜ | INP-1 | `kb_layout = us,es` | Dos distribuciones, alternables | Sin cambios | Migrar. |
| ⬜ | INP-2 | `kb_options = ctrl:nocaps` | Caps Lock actúa como Ctrl | Sin cambios | Migrar. Nota: el default de Omarchy sugiere `compose:caps` — decidir cuál gana. |
| ⬜ | INP-3 | `repeat_rate = 40`, `repeat_delay = 600` | Repetición de tecla | Sin cambios | Migrar (el delay 600 es bastante alto, ¿intencional?). |
| ⬜ | INP-4 | `numlock_by_default = true` | Numlock al arrancar | Sin cambios | Migrar. |
| ⬜ | INP-5 | `touchpad.scroll_factor = 0.4` | Scroll del touchpad más lento | Sin cambios | Migrar. |
| ⬜ | INP-6 | `windowrule = scroll_touchpad 1.5, class (Alacritty\|kitty\|foot)` | Scroll más rápido en terminales | La plantilla nueva lo trae como ejemplo `o.window(...)`; Omarchy 4 tiene tag `terminal` | ¿Uso el tag `terminal` de Omarchy en vez de listar clases a mano? |
| ⬜ | INP-7 | `windowrule = scroll_touchpad 0.2, class com.mitchellh.ghostty` | Idem para ghostty | Igual | ¿Sigo usando ghostty? Si no, borrar. |
| ⬜ | INP-8 | `windowrule = scroll_touchpad 0.8, class Waybar` | Scroll sobre la barra | **Waybar ya no existe** | ⏭️ Borrar. ¿Necesito el equivalente para omarchy-shell? |
| ⬜ | INP-9 | `device { name = tpps/2-elan-trackpoint; sensitivity = -0.5; accel_profile = adaptive }` | Bajar sensibilidad del TrackPoint del ThinkPad | `hl.device({ ... })` | Migrar. Confirmar el nombre del device con `hyprctl devices`. |
| ⬜ | INP-10 | (comentado) gestos de touchpad de 3 dedos | Nunca activado | Omarchy 4 documenta `hl.gesture{}` y gestos por dirección | ¿Los quiero ahora? Merece probarlos. |

## C. Bindings — `bindings.conf` → `bindings.lua`

Omarchy 4 trae de serie **muchísimos más bindings** que Omarchy 3
(`/usr/share/omarchy/default/hypr/bindings/`: applications, clipboard, media,
tiling, utilities, voxtype). Antes de migrar cada binding hay que mirar si ya
existe. Ver todos con `omarchy menu keybindings --print`.

### C.1 Bindings que Omarchy 4 ya da idénticos → candidatos a borrar

| St. | ID | Mi binding | Default de Omarchy 4 | A decidir |
|---|---|---|---|---|
| ⬜ | BND-1 | `SUPER+RETURN` Terminal | igual | ⏭️ Borrar (redundante). |
| ⬜ | BND-2 | `SUPER+ALT+RETURN` Tmux | igual (`omarchy-launch-terminal-tmux`) | ⏭️ Borrar. El mío pasa `--dir` con `omarchy-cmd-terminal-cwd`; comprobar que el default también abre en el cwd. |
| ⬜ | BND-3 | `SUPER+SHIFT+RETURN` / `SUPER+SHIFT+B` Browser | iguales | ⏭️ Borrar ambos. |
| ⬜ | BND-4 | `SUPER+SHIFT+ALT+B` Browser privado | igual | ⏭️ Borrar. |
| ⬜ | BND-5 | `SUPER+SHIFT+M` Spotify / `SUPER+SHIFT+ALT+M` cliamp | iguales | ⏭️ Borrar ambos. |
| ⬜ | BND-6 | `SUPER+SHIFT+N` Editor | igual | ⏭️ Borrar. |
| ⬜ | BND-7 | `SUPER+SHIFT+D` lazydocker | igual | ⏭️ Borrar. |
| ⬜ | BND-8 | `SUPER+SHIFT+G` Signal | igual (`omarchy-launch-signal`) | ⏭️ Borrar. |
| ⬜ | BND-9 | `SUPER+SHIFT+A` ChatGPT / `SUPER+SHIFT+ALT+A` Grok | iguales | ⏭️ Borrar ambos. |
| ⬜ | BND-10 | `SUPER+SHIFT+E` Email (hey) | igual, y añade `SUPER+SHIFT+ALT+E` correo nuevo | ⏭️ Borrar el mío, ganar el extra. |
| ⬜ | BND-11 | `SUPER+SHIFT+Y` YouTube | igual | ⏭️ Borrar. |
| ⬜ | BND-12 | `SUPER+SHIFT+ALT+G` WhatsApp / `SUPER+SHIFT+CTRL+G` Google Messages | iguales | ⏭️ Borrar ambos. |
| ⬜ | BND-13 | `SUPER+SHIFT+X` X / `SUPER+SHIFT+ALT+X` X Post | iguales | ⏭️ Borrar ambos. |
| ⬜ | BND-14 | `SUPER+SHIFT+P` Google Photos (comentado) | ahora existe de serie | ⏭️ Borrar la línea comentada. |
| ⬜ | BND-15 | `SUPER+SHIFT+O` Obsidian (comentado) | ahora existe de serie | ⏭️ Borrar la línea comentada. |

### C.2 Bindings donde choco con un default nuevo de Omarchy 4

Aquí está la parte interesante: Omarchy 4 ocupa teclas que yo usaba para otra
cosa. Cada fila es una decisión real de ergonomía.

| St. | ID | Tecla | Yo la usaba para | Omarchy 4 la usa para | A decidir |
|---|---|---|---|---|---|
| ⬜ | CLA-1 | `SUPER+SPACE` | Dictado voxtype (push-to-talk con `binddr`) | **Menú de Omarchy** (el lanzador principal) | Omarchy 4 ya trae voxtype de serie: `SUPER+CTRL+X` (toggle) y `F9` (push-to-talk). ¿Me adapto a `F9`, o me quedo `SUPER+SPACE` y muevo el menú? |
| ⬜ | CLA-2 | `SUPER+D` | Lanzador (walker) | libre (`SUPER+SPACE` = menú, `SUPER+ALT+SPACE` = menú de apps) | walker ya no existe. ¿Aprendo `SUPER+SPACE`/`SUPER+ALT+SPACE` y borro `SUPER+D`, o remapeo `SUPER+D` al menú de apps? |
| ⬜ | CLA-3 | `SUPER+W` | Pop window out | **Cerrar ventana** | Omarchy 4 pone pop-out en `SUPER+O`. Choque doble: yo uso `SUPER+O` para play/pause. Decidir el trío W/O/Q entero. |
| ⬜ | CLA-4 | `SUPER+SHIFT+Q` | Cerrar ventana | libre | Si adopto `SUPER+W` = cerrar (default), esto se borra. |
| ⬜ | CLA-5 | `SUPER+J` / `SUPER+K` | Foco abajo / arriba (vim) | `SUPER+J` = toggle split; `SUPER+K` = **menú de keybindings** | ¿Mantengo navegación vim h/j/k/l (y desbindeo 2 defaults), o me paso a las flechas que usa Omarchy? |
| ⬜ | CLA-6 | `SUPER+L` | Foco derecha (vim) | **Toggle workspace layout** (tiling ↔ scrolling) | Igual que CLA-5. El layout scrolling tipo niri es nuevo y puede que me interese. |
| ⬜ | CLA-7 | `SUPER+H` | Foco izquierda (vim) | libre | Depende de CLA-5. |
| ⬜ | CLA-8 | `SUPER+SHIFT+H/J/K/L` | Mover ventana (swapwindow) | libre (Omarchy usa `SUPER+SHIFT+flechas`) | Depende de CLA-5. |
| ⬜ | CLA-9 | `SUPER+I` / `SUPER+O` / `SUPER+P` | Spotify: anterior / play-pause / siguiente | `SUPER+O` = pop window, `SUPER+P` = pseudo window | **`playerctl` ya no está instalado.** Omarchy 4 usa `omarchy-shell media next\|playPause\|previous` y lo bindea a las teclas `XF86Audio*`. ¿Me basta con las teclas multimedia del teclado, o quiero atajos SUPER? Ojo: mis bindings eran *específicos de Spotify* (`--player=spotify`), los de Omarchy son del reproductor activo. |
| ⬜ | CLA-10 | `SUPER+SHIFT+I/O/P` | Multimedia de cualquier reproductor | `SUPER+SHIFT+O` = Obsidian, `SUPER+SHIFT+P` = Google Photos | Igual que CLA-9. |
| ⬜ | CLA-11 | `SUPER+X` | Foco a ventana urgente (`focusurgentorlast`) | **Cortar universal** (`SUPER+C/V/X` copiar/pegar/cortar en cualquier app, incluidos paneles) | El portapapeles universal es una feature nueva buena. ¿Muevo "ventana urgente" a otra tecla o lo dejo morir? ¿Lo usaba de verdad? |
| ⬜ | CLA-12 | `SUPER+SHIFT+F` | Screenshot (`smart copy`) | **Gestor de archivos** | Omarchy 4: `PRINT` screenshot, `SUPER+CTRL+C` menú de captura, `SUPER+PRINT` color picker. ¿Me paso a `PRINT`? |
| ⬜ | CLA-13 | `SUPER+SHIFT+C` | Submap de captura | **Calendar (hey)** | Ver SUB-4: el submap de captura es casi todo redundante ahora. |
| ⬜ | CLA-14 | `SUPER+SHIFT+code:61` (slash) | Menú de keybindings | `SUPER+SHIFT+SLASH` = **1Password** | Omarchy 4 pone keybindings en `SUPER+K`. ⏭️ Probable borrar el mío. |
| ⬜ | CLA-15 | `SUPER+COMMA` | Submap de notificaciones | `SUPER+comma` = **descartar última notificación** (+ familia `SUPER+*+comma`) | Ver SUB-3: la familia nueva cubre todo mi submap. |
| ⬜ | CLA-16 | `SUPER+CTRL+P` | Toggle pseudo | **Panel de energía** | Omarchy 4 pone pseudo en `SUPER+P`. ⏭️ Probable borrar. |
| ⬜ | CLA-17 | `SUPER+SHIFT+W` | Typora | **Omawrite** (editor nuevo de Omarchy) | `typora` ya no está instalado. ¿Lo reinstalo, pruebo Omawrite, o me quedo con nvim? |
| ⬜ | CLA-18 | `SUPER+SHIFT+T` | btop | libre (Omarchy usa `SUPER+CTRL+T`) | ¿Me adapto a `SUPER+CTRL+T`? |
| ⬜ | CLA-19 | `unbind SUPER+CTRL+X` | Lo desbindeaba (era "cerrar todo" en Omarchy 3) | Ahora es **toggle de dictado voxtype** | Reconsiderar: ya no es peligroso, es útil. Ver CLA-1. |

### C.3 Bindings propios sin equivalente — decidir si los mantengo

| St. | ID | Mi binding | Qué hace | A decidir |
|---|---|---|---|---|
| ⬜ | BND-16 | `SUPER+Q` Cambiar layout de teclado + OSD | `hyprctl switchxkblayout all next` + script de OSD | Omarchy 4 tiene módulo `omarchy.keyboard-layout` en la barra. ¿Existe ya un atajo de serie? ¿El OSD lo hace `omarchy-osd`? Ver SCR-1. |
| ⬜ | BND-17 | `SUPER+N` Workspace vacío | `workspace, empty` | ¿Lo uso? Omarchy 4 tiene `SUPER+TAB`/`SUPER+SHIFT+TAB` para navegar workspaces. |
| ⬜ | BND-18 | `SUPER+apostrophe` / `SUPER+SHIFT+apostrophe` | Último workspace / mover al último (costumbre de i3) | Omarchy 4: `SUPER+CTRL+TAB` = workspace anterior. ¿Me adapto? |
| ⬜ | BND-19 | `SUPER+BACKSLASH` Toggle split | `layoutmsg togglesplit` | Omarchy 4 lo pone en `SUPER+J`. Redundante si acepto los defaults. |
| ⬜ | BND-20 | `SUPER+SHIFT+F` → ver CLA-12 | — | — |

### C.4 Cosas nuevas de Omarchy 4 que quizá quiera aprender

No es migración, es cosecha. Al revisar los bindings salieron features que no
existían en Omarchy 3 y puede que me interesen.

| St. | ID | Feature nueva | Qué es |
|---|---|---|---|
| ⬜ | NEW-1 | `SUPER+C/V/X` | Portapapeles universal que funciona también en terminales (traduce a `CTRL+INSERT`/`SHIFT+INSERT`) y en paneles |
| ⬜ | NEW-2 | Layout `scrolling` | Layout lateral tipo niri, alternable con `SUPER+L` |
| ⬜ | NEW-3 | `SUPER+CTRL+{A,B,D,W,P}` | Paneles de audio / bluetooth / display / red / energía desde la barra |
| ⬜ | NEW-4 | `SUPER+CTRL+R` | Recordatorios (`omarchy-reminder`) |
| ⬜ | NEW-5 | `SUPER+CTRL+PRINT` | OCR: extraer texto de un screenshot |
| ⬜ | NEW-6 | `SUPER+CTRL+Q` | Calculadora (`omacalc`) |
| ⬜ | NEW-7 | `SUPER+SHIFT+CTRL+A` | Agentes (`omarchy-agent --pick`) + módulo `omarchy.agents` en la barra |
| ⬜ | NEW-8 | `SUPER+CTRL+Z` | Zoom de pantalla |
| ⬜ | NEW-9 | Captura con teclado | Al seleccionar región: `RETURN` ventana, `TAB` siguiente ventana, flechas |
| ⬜ | NEW-10 | `SUPER+CTRL+RETURN` | `herdr` (nuevo) — averiguar qué es |
| ⬜ | NEW-11 | `omarchy.tailscale` | Módulo de barra para Tailscale |

## D. Submaps — `submaps.conf` + `submaps/*.conf`

Los submaps ahora tienen API Lua nativa: `hl.define_submap(name, reset_or_fn, fn)`
y evento `hl.on("keybinds.submap", cb)`. Pero primero: ¿siguen teniendo sentido?

| St. | ID | Submap | Qué contiene | En quattro | A decidir |
|---|---|---|---|---|---|
| ⬜ | SUB-1 | `bluetooth` (`SUPER+B`) | 6 dispositivos por MAC (Sony XM3/XM6, Bose, Bose Ultra, Pixel Buds, barra de sonido), desconectar, toggle A2DP/HFP | Genuinamente propio: conecta a MACs concretas vía `~/.local/bin/bt`. Omarchy 4 tiene panel bluetooth (`SUPER+CTRL+B`) pero no atajos por dispositivo | **El candidato más claro a mantener.** Migrar a `hl.define_submap`. ¿O el panel nuevo ya es suficientemente rápido? |
| ⬜ | SUB-2 | `apps` (`SUPER+R`) | Spotify, Browser, Slack, Telegram, WhatsApp, Nautilus, btop, Docker, YouTube, Gemini | Casi todo existe ya como `SUPER+SHIFT+*` de serie. Únicos no cubiertos: **Slack**, **Telegram**, **Gemini** | ¿Borro el submap y añado 3 bindings sueltos? ¿O el submap me resulta más cómodo que recordar `SUPER+SHIFT+letra`? |
| ⬜ | SUB-3 | `notifications` (`SUPER+COMMA`) | dismiss last/all/group, toggle DND, invoke, restore — todo vía `makoctl` | **Totalmente cubierto de serie**: `SUPER+comma` (última), `SUPER+SHIFT+comma` (todas), `SUPER+CTRL+comma` (silenciar), `SUPER+ALT+comma` (invocar), `SUPER+SHIFT+ALT+comma` (historial). Y `makoctl` no existe | ⏭️ Candidato claro a borrar entero. Lo único sin equivalente directo: "dismiss group". |
| ⬜ | SUB-4 | `capture` (`SUPER+SHIFT+C`) | screenshot editar/clipboard, grabación, color picker, share | Casi todo de serie: `PRINT`, `SUPER+CTRL+C` (menú captura), `ALT+PRINT` (grabar), `SUPER+PRINT` (picker), `SUPER+CTRL+S` (share) | ⏭️ Candidato a borrar. El menú `SUPER+CTRL+C` es básicamente mi submap hecho por Omarchy. |
| ⬜ | SUB-5 | `resize` (`SUPER+SHIFT+R`) | Redimensionar con hjkl y flechas, pasos de 50px | Omarchy 4 tiene resize en `SUPER+code:20/21` con 3 granularidades (25/100/300px) | ¿El submap sigue siendo más cómodo que los atajos directos? Yo pienso en vim, Omarchy no. |
| ⬜ | SUB-6 | Mecánica del submap | Cada binding hace `hyprctl dispatch submap reset; comando`, más `catchall`/`ESCAPE`/`RETURN` para salir | La API Lua nueva puede hacerlo más limpio (`hl.define_submap` con reset automático) | Si sobrevive algún submap, rehacer la mecánica bien en vez de traducirla. |

## E. Reglas de ventana — `windowrules.conf`

| St. | ID | Regla | A decidir |
|---|---|---|---|
| ⬜ | WR-1 | Spotify → workspace 10 | ¿Sigo queriendo apps clavadas a workspaces? Migrar con `o.window("Spotify", { workspace = "10", silent = true })`. |
| ⬜ | WR-2 | slack → workspace 9 | Idem. |
| ⬜ | WR-3 | ferdium → workspace 9 | ¿Sigo usando Ferdium? Comprobar si está instalado. |
| ⬜ | WR-4 | `chrome-web.whatsapp.com__-Default` → workspace 9 | La clase depende de cómo lance el webapp. Verificar que no cambió en quattro. |
| ⬜ | WR-5 | teams-for-linux → workspace 8 | ¿Sigo usándolo? |
| ⬜ | WR-6 | zen → workspace 5 | Migrar. |
| ⬜ | WR-7 | `chrome-web.telegram.org__-Default` → workspace 3 | Igual que WR-4. |
| ⬜ | WR-8 | — | Omarchy 4 trae reglas de ventana propias en `default/hypr/apps/*.lua` (1password, pip, steam, qemu…). Revisar si alguna choca. |

## F. Autostart — `autostart.conf`

| St. | ID | Entrada | Qué hacía | En quattro | A decidir |
|---|---|---|---|---|---|
| ⬜ | AUT-1 | `exec-once = uwsm-app -- hyprsunset` | Filtro de luz azul | `hyprsunset` sigue instalado y `hyprsunset.conf` sigue siendo `.conf`. Pero Omarchy 4 tiene toggle propio de nightlight (`SUPER+CTRL+N`) | ¿Lo arranca ya Omarchy 4 solo? Comprobar antes de duplicarlo. |
| ⬜ | AUT-2 | `exec-once = eww daemon` | Daemon de eww para el which-key | eww sigue instalado | Depende del bloque G. |
| ⬜ | AUT-3 | `exec-once = ~/.config/eww/which-key-daemon.sh` | Popup which-key | Depende del bloque G | — |
| ⬜ | AUT-4 | `exec-once = ~/.config/hypr/scripts/screencast-dnd` | DND automático al compartir pantalla | Usa `makoctl`, **roto** | Ver SCR-2. |

## G. Which-key (eww) — `~/.config/eww/`

Popup propio que muestra las teclas disponibles al entrar en un submap.
Documentado en [which-key.md](which-key.md).

| St. | ID | Entrada | Estado | A decidir |
|---|---|---|---|---|
| ⬜ | WK-1 | ¿Sigo queriendo which-key? | Depende de cuántos submaps sobrevivan al bloque D | **Decidir esto primero.** Si solo sobrevive el submap de bluetooth, quizá no compense mantener un daemon + eww + una hoja de estilo. |
| ⬜ | WK-2 | `which-key-daemon.sh` | Escucha el evento `submap` del socket IPC vía `socat` y parsea `hyprctl binds` | Ambas cosas siguen existiendo. Pero la API Lua tiene `hl.on("keybinds.submap", cb)`: mucho más limpio que socat + awk |
| ⬜ | WK-3 | Parseo de `hyprctl binds` | Hack de texto porque `hyprctl binds -j` daba JSON inválido en Hyprland 0.56 (ver commit `8acedd6`) | ¿Está arreglado en 0.56.2? Comprobar `hyprctl binds -j \| jq .`. Si sí, simplificar. |
| ⬜ | WK-4 | Descripciones de los binds | El daemon filtra por `description` no vacía | Confirmar que `o.bind(keys, desc, ...)` sigue exponiendo `description` en `hyprctl binds` |
| ⬜ | WK-5 | Color del borde | Lo saca de `~/.config/omarchy/current/theme/swayosd.css` | swayosd ya no existe y la ruta del tema cambió a `~/.local/state/omarchy/current` | Buscar el equivalente en el tema de quattro. |
| ⬜ | WK-6 | `eww.yuck` / `eww.scss` | Widget y estilos | Sin cambios previsibles | Revisar tras WK-1. |

## H. Scripts propios de `hypr/scripts/`

| St. | ID | Script | Qué hace | Estado | A decidir |
|---|---|---|---|---|---|
| ⬜ | SCR-1 | `keyboard-layout-osd` | Tras cambiar de layout, muestra un OSD con el nombre | **Roto**: usa `swayosd-client` | `omarchy-osd` es el reemplazo. Pero: Omarchy 4 tiene módulo `omarchy.keyboard-layout` en la barra, quizá el OSD ya no haga falta. |
| ⬜ | SCR-2 | `screencast-dnd` | Escucha DBus (portal ScreenCast) y activa DND al compartir pantalla, respetando el DND manual | **Roto**: usa `makoctl mode` y `~/.local/bin/dnd-toggle` | Reescribir con `omarchy-toggle-notification-silencing`. ¿O Omarchy 4 ya silencia al compartir? Comprobar antes. |

## I. Scripts de `bin/.local/bin/`

| St. | ID | Script | Qué hace | Estado | A decidir |
|---|---|---|---|---|---|
| ⬜ | BIN-1 | `dnd-toggle` | Toggle DND en mako + OSD + refresco de waybar | **Roto por triple**: `makoctl`, `swayosd-client` y `pkill -RTMIN+9 waybar` | ⏭️ Probable borrar entero: `omarchy-toggle-notification-silencing` hace lo mismo con su propio indicador. |
| ⬜ | BIN-2 | `bt` | Conecta a dispositivos bluetooth por MAC (alias: sony, sony3, bose, ultra, pixel, soundbar) | Funciona (solo usa `bluetoothctl`/`rfkill`) | Se queda. Quizá simplificarlo con `omarchy-bluetooth-device`. |
| ⬜ | BIN-3 | `bt-toggle` | Alterna perfil A2DP ↔ HFP del auricular conectado (para usar el micro) | Funciona (usa `pactl`), **pero** acaba en `pkill -RTMIN+10 i3blocks` — residuo de la época de i3 | Limpiar la línea de i3blocks. ¿Existe equivalente en Omarchy 4 (`omarchy-audio-tuning`)? |
| ⬜ | BIN-4 | `zen-open-url` | Abre URLs en el contenedor de Zen según `WEBAPP_CONTEXT` | Funciona | Ver bloque J. |
| ⬜ | BIN-5 | resto (`analyze_code`, `llm_spend`, `voxtype-clean-transcript`) | Sin relación con Omarchy | OK | Solo verificar que siguen funcionando. |

## J. Webapps

La migración regeneró los 3 lanzadores **preinstalados** de Omarchy y se llevó
mis personalizaciones. Los webapps que creé yo (ChatGPT, GitHub, Outlook,
Gemini, Telegram, OneDrive, MicrosoftToDo, Tailscale…) están intactos.

| St. | ID | Entrada | A decidir |
|---|---|---|---|
| ⬜ | WEB-1 | WhatsApp: perdió `env WEBAPP_CONTEXT=Personal` y el icono propio | Restaurar. ¿O renombrar el `.desktop` para que Omarchy no lo pise en la próxima actualización? |
| ⬜ | WEB-2 | YouTube: idem | Igual que WEB-1. |
| ⬜ | WEB-3 | Google Photos: idem | Igual que WEB-1. |
| ⬜ | WEB-4 | Iconos propios | `~/.local/share/applications/icons` → renombrado a `.bak`. Los nuevos `.desktop` usan nombres de icono del tema (`whatsapp`, `youtube`) | ¿Recupero mis PNGs o me quedo con los iconos del tema? |
| ⬜ | WEB-5 | El patrón entero | ¿Sigue teniendo sentido la integración open-in-zen (`WEBAPP_CONTEXT` + `zen-open-url`) con el `omarchy-launch-webapp` nuevo? Ver [webapps.md](webapps.md) |
| ⬜ | WEB-6 | `install-webapps.sh` | Comparar con `omarchy-webapp-install` / `omarchy-webapp-remove` de quattro. ¿Sigue haciendo falta mi script? |

## K. Barra: waybar → omarchy-shell

`~/.config/omarchy/shell.json` ya existe con la config por defecto (módulos
`omarchy.*`, `plugins: []`). Mi `config.jsonc` de waybar tenía 13 módulos a la
derecha y 6 en el centro.

| St. | ID | Módulo que tenía | ¿Existe en omarchy-shell? | A decidir |
|---|---|---|---|---|
| ⬜ | BAR-1 | workspaces, clock, weather, update, language, bluetooth, network, tray | Sí (`omarchy.workspaces`, `.clock`, `.weather`, `.system-update`, `.keyboard-layout`, `.bluetooth`, `.network`, `.tray`) | Nada que hacer, ya están. |
| ⬜ | BAR-2 | `pulseaudio` + `backlight` | `omarchy.audio` y `omarchy.monitor` | Verificar que cubren scroll para volumen/brillo. |
| ⬜ | BAR-3 | `cpu`, `memory`, `temperature`, `disk` (con iconos de barritas) | **No hay equivalente directo** | ¿Los echo de menos, o me basta con `SUPER+CTRL+T` (btop)? Si los quiero: `~/.config/omarchy/plugins` + `plugins: []` en shell.json. |
| ⬜ | BAR-4 | `battery` con formato de vatios | `omarchy.power` | Comprobar si muestra W↓/W↑ como el mío. |
| ⬜ | BAR-5 | `power-profiles-daemon` | Posiblemente dentro de `omarchy.power` | Verificar. |
| ⬜ | BAR-6 | `mpris` (artista - título) dentro de un grupo desplegable | Sin equivalente visible | ¿Lo quiero? Omarchy tiene `omarchy-shell media`. |
| ⬜ | BAR-7 | `group/tray-expander` (tray plegable) | `omarchy.tray` sin drawer | ¿Me molesta el tray desplegado? |
| ⬜ | BAR-8 | `custom/voxtype` (estado del dictado) | Ver si `omarchy.indicators` ya lo incluye (voxtype es de serie en quattro) | Verificar. |
| ⬜ | BAR-9 | `custom/dnd` + `custom/notification-silencing-indicator` + `custom/idle-indicator` + `custom/screenrecording-indicator` | `omarchy.indicators` los agrupa | ⏭️ Probable borrar todos, incluido `waybar/scripts/dnd-status`. |
| ⬜ | BAR-10 | Clock con calendario anual y `on-click-middle` para timezone | `omarchy.clock` (tiene `birthYear`/`lifeExpectancy` 🙂) y `omarchy-menu-timezone` | Comparar y ajustar formato (yo usaba `ddd HH:mm` con locale `en_GB`). |
| ⬜ | BAR-11 | El directorio `hyprland/.config/waybar/` entero | waybar desinstalado | Decidir: borrar del repo, o dejarlo sin stowear como referencia histórica. |
| ⬜ | BAR-12 | Integración con el tema | `waybar/style.css` hacía `@import` del tema actual | Ver cómo tematiza omarchy-shell (`~/.config/omarchy/themed/`?). |

## L. Idle y lock

| St. | ID | Entrada | Qué tenía | En quattro | A decidir |
|---|---|---|---|---|---|
| ⬜ | IDLE-1 | Screensaver a los 150s | `listener` en `hypridle.conf` | `shell.json` → `"idle": { "screensaver": 150 }` — **ya coincide** | Nada que hacer. Confirmar. |
| ⬜ | IDLE-2 | Lock a los 152s | `listener` con el truco de "mitad + 2s margen" porque el screensaver reseteaba el timer | `shell.json` → `"idle": { "lock": 300 }` | El hack ya no hace falta. Decidir si 300s me vale o lo bajo. |
| ⬜ | IDLE-3 | `lock_cmd`, `before_sleep_cmd`, `after_sleep_cmd`, `inhibit_sleep` | Lock antes de suspender, despertar pantalla, esperar a PAM | Nativo en Omarchy 4 (`omarchy-system-sleep-lock`, `omarchy-system-sleep-monitor`) | ⏭️ Probable borrar `hypridle.conf` entero. Verificar que suspender/despertar funciona. |
| ⬜ | IDLE-4 | `hyprlock.conf` | Estilo de la pantalla de bloqueo (input field, fuente, blur del fondo, huella deshabilitada) | **hyprlock desinstalado**. La pantalla de bloqueo es de omarchy-shell | ⏭️ Borrar. ¿Se puede personalizar la nueva? ¿Y la huella? |
| ⬜ | IDLE-5 | `omarchy-toggle-idle` | — | Nuevo: `SUPER+CTRL+I` toggle de bloqueo por inactividad | Aprender. |

## M. Ficheros del repo a limpiar o rehacer

| St. | ID | Fichero | Problema |
|---|---|---|---|
| ⬜ | REP-1 | `hyprland/.config/hypr/hyprland.conf` | Ya no lo lee nadie (Hyprland usa `hyprland.lua`). Borrar al final del bloque A–F. |
| ⬜ | REP-2 | `hyprland/.config/hypr/hypridle.conf` | hypridle desinstalado. Ver IDLE-3. |
| ⬜ | REP-3 | `hyprland/.config/hypr/hyprlock.conf` | hyprlock desinstalado. Ver IDLE-4. |
| ⬜ | REP-4 | `hyprland/.config/hypr/hyprsunset.conf` | Sigue vivo y sigue siendo `.conf` en quattro. Solo verificar. |
| ⬜ | REP-5 | `hyprland/.config/hypr/xdph.conf` | Sigue vivo (`allow_token_by_default`, `custom_picker_binary`). Comparar con el default de quattro. |
| ⬜ | REP-6 | `install-hyprland.sh` | Instala `hypridle`, `hyprlock`, `waybar`, `mako`, `swayosd-git` y clona omarchy a mano. Obsoleto de arriba abajo. ¿Reescribir o borrar? |
| ⬜ | REP-7 | `docs/hyprland.md` | Describe la arquitectura de Omarchy 3 (waybar, mako, rutas viejas). Reescribir al terminar. |
| ⬜ | REP-8 | `docs/which-key.md` | Rutas de tema viejas y `swayosd.css`. Depende del bloque G. |
| ⬜ | REP-9 | `docs/webapps.md` | Verificar contra el bloque J. |
| ⬜ | REP-10 | `i3/` | Herencia de i3, ya no se usa. ¿Sigue teniendo sentido en el repo? (No es de quattro, pero salió al revisar.) |
| ⬜ | REP-11 | `CLAUDE.md` | La regla "NEVER modify `~/.local/share/omarchy/`" hay que actualizarla: ahora es `/usr/share/omarchy` y es un paquete pacman. |
| ⬜ | REP-12 | `.luarc.json` | Lo puso la migración. Está bien (apunta a los stubs). Solo confirmar que lo quiero versionado. |

## N. Backups de la migración por revisar

Ninguno estaba en el repo (los gestionaba Omarchy), pero conviene diffear cada
uno contra el default nuevo por si tenía algo mío dentro.

| St. | ID | Backup |
|---|---|---|
| ⬜ | BAK-1 | `~/.config/chromium-flags.conf` (permisos 600, sospechoso de tener algo propio) |
| ⬜ | BAK-2 | `~/.config/brave-flags.conf` |
| ⬜ | BAK-3 | `~/.config/mimeapps.list` (asociaciones de tipo de fichero, probable que tenga cosas mías) |
| ⬜ | BAK-4 | `~/.config/xdg-terminals.list` |
| ⬜ | BAK-5 | `~/.config/uwsm/env` y `~/.config/uwsm/default` |
| ⬜ | BAK-6 | `~/.config/environment.d/fcitx.conf` |
| ⬜ | BAK-7 | `~/.config/fontconfig/fonts.conf` |
| ⬜ | BAK-8 | `~/.config/fastfetch/config.jsonc` |
| ⬜ | BAK-9 | `~/.config/imv/config`, `~/.config/xournalpp/settings.xml` |
| ⬜ | BAK-10 | `~/.config/hyprland-preview-share-picker/config.yaml` |
| ⬜ | BAK-11 | `~/.local/share/omarchy.…bak` (el clone viejo entero — mirar si tenía parches locales antes de borrarlo) |
| ⬜ | BAK-12 | `~/.config/walker.…bak`, `mako.…bak`, `swayosd.…bak` (¿tenían config propia que valga la pena replicar?) |

## O. Verificaciones sueltas

| St. | ID | Qué comprobar |
|---|---|---|
| ⬜ | CHK-1 | nvim: quattro trae paquete `omarchy-nvim`; el repo stowea su propio LazyVim en `vim/.config/nvim`. ¿Colisionan? |
| ⬜ | CHK-2 | `remote_clipboard.lua` de nvim (OSC 52 para tmux/SSH) — sigue funcionando? |
| ⬜ | CHK-3 | Voxtype: modo remoto contra powerant. ¿Sobrevivió la config a quattro? |
| ⬜ | CHK-4 | `ferdium`, `teams-for-linux`, `typora`, `obsidian`, `zen` — ¿qué sigue instalado? (afecta a WR-3, WR-5, CLA-17) |
| ⬜ | CHK-5 | Tema: ¿el tema que usaba existe en quattro? La ruta cambió a `~/.local/state/omarchy/current/theme` |
| ⬜ | CHK-6 | `githooks/post-merge` — ¿sigue teniendo sentido lo que hace? |
| ⬜ | CHK-7 | `pacman/` en el repo — ¿la lista de paquetes hay que actualizarla tras quattro? |

---

## Registro de decisiones

Una línea por decisión tomada, con el motivo. Esto es la memoria de la
migración: en seis meses el *por qué* vale más que el *qué*.

| Fecha | ID | Decisión | Motivo |
|---|---|---|---|
| 2026-08-22 | — | Snapshot en rama `quattro`, `master` intacto | Poder volver al Omarchy 3 funcionando mientras se migra sin prisa |
