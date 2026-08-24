# Migración a Omarchy quattro

> **Lee "Cómo trabajamos" antes de tocar nada.** Esto no es una migración
> rápida: es una lista para revisar entrada por entrada, decidiendo con
> criterio. Se tacha sesión a sesión y no hay prisa.

- **Rama**: `quattro` · **Rollback**: `master` (último Omarchy 3 funcionando)
- **Punto de partida**: snapshot del working tree tras `omarchy-upgrade-to-quattro` (2026-08-22)
- **Versiones**: Omarchy 4.0.0.alpha · Hyprland 0.56.2

---

## Cómo trabajamos

El objetivo **no** es recuperar el escritorio cuanto antes. Es **entender qué
tenía, por qué lo tenía, y decidir si lo sigo queriendo**. Omarchy 4 trae
muchísimo más de serie que Omarchy 3, así que buena parte de esta config eran
parches para problemas ya resueltos. Migrar a ciegas sería arrastrar deuda.

Estas reglas se acordaron explícitamente. No se cambian sin volver a hablarlo.

1. **Una entrada a la vez.** Se coge una, se entiende y se decide. Nada "de paso".
2. **Antes de decidir, entender.** Hay que poder responder: ¿qué hacía
   exactamente? ¿por qué lo puse? ¿sigue existiendo el problema que resolvía?
3. **Sin sesgo por defecto.** Ni "adóptalo porque es lo nuevo" ni "consérvalo
   porque es lo mío". Cada entrada se decide en frío y ninguna dirección tiene
   ventaja. El coste de esto lo paga el agente, no el usuario: cada entrada
   llega con los hechos ya investigados para que decidir cueste segundos.
4. **Los hechos son trabajo del agente.** Si una decisión depende de cómo
   funciona algo, se investiga y se documenta aquí — no se pregunta al usuario
   ni se supone.
5. **Recomendar sí, decidir no.** El agente puede recomendar, pero en línea
   aparte y marcada como suya. Nunca en la misma voz que los hechos, y nunca
   como veredicto ya puesto en la columna de "a decidir".
6. **Se permite y se espera la prueba de campo.** Las entradas de ergonomía no
   se resuelven sentados. Una entrada puede quedar en 🔍 mientras se vive con
   ella, pero todo 🔍 lleva escrito **qué** se está probando y **cuándo** se
   decide, para que no se convierta en un cajón donde muere todo.
7. **Escribir código nuevo está permitido.** Si al revisar una entrada resulta
   que hace falta un plugin de la barra o reescribir un script, se hace aquí.
8. **Los `.conf` muertos se borran en el commit de su propia entrada.** Nada de
   arrastrarlos "por si acaso": `git show master:<ruta>` es el archivo.
9. **Esto acaba cuando el escritorio se siente mío.** No hace falta agotar la
   lista. Lo que quede sin revisar se abandona sin culpa — por eso el orden
   importa, y por eso la cola está marcada como tal en el [Anexo B](#anexo-b--la-cola-probablemente-nunca).
10. **Atajos: lo más estándar posible.** Ante dos atajos que valen, gana el de
    Omarchy. Un binding propio es deuda: cada default nuevo puede chocar con él,
    y cada upgrade obliga a revisarlo (esta migración *es* la factura de haberlo
    hecho al revés). Un binding propio se justifica solo si el default no existe
    o duele de verdad — y entonces se anota **por qué** aquí, para que el
    siguiente que lo vea no tenga que adivinarlo. Esto **no** aplica al teclado
    en sí (TEC-1): la disposición y `kb_options` no son atajos de Omarchy, son
    memoria muscular de años y ergonomía de escribir en dos idiomas.

**Idioma**: este documento en español (es donde se piensan las decisiones), los
commits en inglés como el resto del repo.

**Estados**: ⬜ pendiente · 🔍 en prueba de campo · ✅ decidido y hecho · ⏭️ descartado

**Flujo de sesión**: elegir un bloque → repasar sus entradas → decidir →
aplicar → `hyprctl reload` y probar → commit pequeño → actualizar estados y el
[registro de decisiones](#registro-de-decisiones).

---

## Qué cambió en quattro

| Área | Omarchy 3 | Omarchy quattro |
|---|---|---|
| Instalación | git clone en `~/.local/share/omarchy` | paquete pacman en `/usr/share/omarchy` (symlink de compat) |
| Config Hyprland | `hyprland.conf` + `source =` | **`hyprland.lua`** (`hyprctl systeminfo` → `configProvider: lua`) |
| Estado | `~/.config/omarchy/current` | `~/.local/state/omarchy/current` |
| Barra | waybar | `omarchy-shell` (quickshell) |
| Notificaciones | mako | omarchy-shell |
| OSD volumen/brillo | swayosd | `omarchy-osd` |
| Lanzador | walker | `omarchy-menu` (`SUPER+SPACE`) |
| Idle / lock | hypridle + hyprlock | nativo, config en `~/.config/omarchy/shell.json` |
| Config barra | `~/.config/waybar/config.jsonc` | `~/.config/omarchy/shell.json` |
| Control multimedia | `playerctl` | `omarchy-shell media …` |

**Comandos que usaba y ya no existen**: `omarchy-launch-walker`, `playerctl`,
`makoctl`, `swayosd-client`, `hyprlock`, `hypridle`, `omarchy-launch-wifi`,
`omarchy-launch-bluetooth`, `omarchy-launch-audio`, `omarchy-tz-select`.
**Apps que ya no están instaladas**: `typora`, `slack`, `ferdium`, `i3`, `i3blocks`.

**Ojo**: `~/.config/hypr` es un symlink al directorio del repo, así que la
migración de Omarchy **escribió dentro del repo**. Los `.lua` nuevos y el cambio
de ruta del tema en `hyprland.conf` los hizo ella. Corolario útil: borrar un
fichero del repo lo quita de la config viva al instante, sin líos de stow.

Backups que dejó la migración:
`find ~/.config ~/.local/share -maxdepth 2 -name '*omarchy-upgrade-to-quattro*'`

---

## Referencia: la API Lua nueva

`~/.config/hypr/hyprland.lua` carga `bootstrap.lua` (mete `~/.config` en
`package.path`), luego `require("default.hypr.omarchy")` (todos los defaults), y
después los módulos propios: `hypr.monitors`, `hypr.input`, `hypr.bindings`,
`hypr.looknfeel`, `hypr.autostart`. Lo propio se carga **después**, así que gana.

Dos globales: **`hl`** (API de Hyprland) y **`o`** (helpers de Omarchy).

- Stubs con tipos: `/usr/share/hypr/stubs/hl.meta.lua` (ya apuntado desde `.luarc.json`)
- Helpers de Omarchy: `/usr/share/omarchy/default/hypr/helpers.lua`
- Defaults que se cargan antes: `/usr/share/omarchy/default/hypr/`
- Ver bindings actuales: `omarchy menu keybindings --print`

| Sintaxis `.conf` | Equivalente Lua |
|---|---|
| `monitor = ...` | `hl.monitor({ output=, mode=, position=, scale=, transform= })` |
| `env = K,V` | `hl.env("K", "V")` |
| `input { ... }` / `general { ... }` | `hl.config({ input = { ... } })` |
| `device { name = ... }` | `hl.device({ ... })` |
| `bindd = MOD, KEY, Desc, exec, cmd` | `o.bind("SUPER + KEY", "Desc", "cmd")` |
| `binddr` (al soltar) | `o.bind(keys, desc, cmd, { release = true })` |
| repetición / durante lock | `{ repeating = true }` / `{ locked = true }` |
| `unbind = MOD, KEY` | `hl.unbind("SUPER + KEY")` |
| `windowrule = X, match:class C` | `o.window("C", { ... })` |
| `exec-once = uwsm-app -- cmd` | `o.launch_on_start("cmd")` |
| `exec-once = cmd` | `o.exec_on_start("cmd")` |
| `submap = name` | `hl.define_submap(name, reset_or_fn, fn)` |
| `gesture = ...` | `hl.gesture({ fingers=, direction=, action= })` |

Azúcar de Omarchy para lanzar: `{ omarchy = "browser" }`,
`{ webapp = "https://…", focus = true }`, `{ tui = "btop", focus = true }`,
`{ launch = "obsidian", focus = "^obsidian$" }`.

**Dato importante para el which-key**: con config Lua, `hyprctl binds` ya no
expone el comando — todos los bindings salen como `dispatcher: __lua, arg: N`.
Las `description` **sí** sobreviven (226 de 228). Y `hyprctl binds -j` vuelve a
ser JSON válido en 0.56.2, así que el parseo con `awk` del commit `8acedd6` ya
no hace falta.

---

## Investigación cerrada: el teclado

Documentado con detalle para no tener que volver a investigarlo. **Decisión
tomada** (2026-08-23), en 🔍 prueba de campo.

### Lo que hace Omarchy 4 por defecto

`kb_options = "compose:caps,shift:both_capslock_cancel"`, **hardcodeado** en
`default/hypr/input.lua` — no se lee de `vconsole.conf`. En cambio `kb_layout` y
`kb_variant` **sí** salen de `/etc/vconsole.conf` (`XKBLAYOUT`, `XKBVARIANT`,
se cambian con `localectl`). Asimetría a recordar.

Omarchy solo añade un segundo layout automáticamente si el primero es de
escritura **no latina** (árabe, ruso, griego, tailandés…). Para `es`, que es
latino, asume que no hace falta: la intención de diseño es **quedarse en `us` y
componer los acentos** en vez de cambiar de layout.

`compose:caps` pone Compose en Caps Lock. `shift:both_capslock_cancel` devuelve
el Caps Lock real con los dos Shift a la vez (uno solo lo cancela).

### El conflicto

`ctrl:nocaps` y `compose:caps` remapean **la misma tecla física**, así que son
incompatibles. Consecuencia histórica: `~/.XCompose` tiene dos secuencias
personales (`Multi_key space n` → nombre, `Multi_key space e` → email) que
llevaban muertas desde que `input.conf` puso `ctrl:nocaps`.

### Las opciones, comparadas

| | `compose:caps` (Omarchy) | **`us(altgr-intl)`** | layout `es` | `us(intl)` |
|---|---|---|---|---|
| `ñ` | Compose, Shift+`` ` ``, n | **AltGr+n** | n | AltGr+n |
| `¿` | Compose, Shift+/, Shift+/ | **AltGr+/** | Shift+= | AltGr+/ |
| `á` | Compose, `'`, a | **AltGr+a** | `'`, a | AltGr+a |
| `¡` | Compose, !, ! | **AltGr+Shift+1** | Shift+1 | AltGr+1 |
| `'` `"` `` ` `` `~` | normales | **normales** | movidas de sitio | **dead keys** ✗ |
| ¿cambiar de layout? | no | **no** | sí | no |
| ¿compatible con Caps=Ctrl? | **no** | **sí** | sí | sí |

- **`us(intl)`** queda descartada: convierte `'` `"` `` ` `` `~` en dead keys, o
  sea infierno para escribir código.
- **`us(altgr-intl)`** hace `include "us(intl)"` y luego **mueve los dead keys
  al nivel 3**, así que hereda ñ/¿/acentos directos pero deja las comillas
  normales. Trae `include "level3(ralt_switch)"`, no hace falta opción extra.
- **`es`** es el que menos pulsaciones gasta, pero obliga a cambiar de layout y
  mueve todos los símbolos de programación.

### Decisión

```
kb_layout  = us
kb_variant = altgr-intl
kb_options = ctrl:nocaps,compose:rctrl,shift:both_capslock_cancel
```

- **Caps Lock = Ctrl** (memoria muscular de años).
- **Ctrl derecho = Compose** — no se usaba, y así resucitan las dos secuencias
  de `~/.XCompose`.
- **`shift:both_capslock_cancel` se conserva a propósito**: sin él no quedaría
  ninguna forma de activar el Caps Lock real. Es una *adición* respecto a lo que
  había en Omarchy 3 (donde `kb_options` era solo `ctrl:nocaps`), no un
  arrastre — si molesta, se quita.
- **Coste aceptado**: `AltGr` (Alt derecho) pasa a ser `ISO_Level3_Shift` y deja
  de funcionar como Alt. El Alt izquierdo sigue intacto, así que los `ALT+TAB`
  de Omarchy funcionan igual.

Verificado compilando el keymap con
`xkbcli compile-keymap --layout us --variant altgr-intl --options ...`:
`<CAPS>` → `Control_L`, `<RCTL>` → `Multi_key`, `<LCTL>` → `Control_L`,
`<AB06>` → `n N ntilde Ntilde`, `<AC11>` → `apostrophe quotedbl dead_acute dead_diaeresis`.

**🔍 Qué se está probando** (decidir hacia el 2026-08-30): que no se echa de
menos el Alt derecho, y que `AltGr+n` sale natural escribiendo rápido. Si a los
cuatro días sigue raro, la alternativa es `us,es` + `ctrl:nocaps` + un binding
para alternar.

---

# LA LISTA

Ordenada por impacto en "esto vuelve a ser mío", no por tema. Lo de arriba es lo
que más se nota; lo de abajo es lo que probablemente nunca se toque.

## Bloque 1 — Teclado ✅🔍

| St. | ID | Entrada | Notas |
|---|---|---|---|
| ✅ | TEC-1 | `us` + `altgr-intl` + `ctrl:nocaps,compose:rctrl,shift:both_capslock_cancel` | Aplicado en `input.lua`. Ver la investigación arriba. |
| 🔍 | TEC-2 | Prueba de campo de TEC-1 | Alt derecho y fluidez de `AltGr+n`. Decidir ~2026-08-30. |
| ⬜ | TEC-3 | `repeat_delay = 600` | Omarchy pone 250. `repeat_rate` ya coincide (40). ¿600 era intencional o inercia? Único valor de input que difiere del default. |
| ⬜ | TEC-4 | `SUPER+Q` cambiar layout + `hypr/scripts/keyboard-layout-osd` | Con un solo layout no hay nada que alternar, y el script usa `swayosd-client` (desinstalado; sustituto `omarchy-osd`). Queda vivo o se va entero según cómo acabe TEC-2. |
| ⬜ | TEC-5 | Módulo `omarchy.keyboard-layout` en `shell.json` | Con un solo layout muestra siempre "US". ¿Se quita de la barra? |
| ⬜ | TEC-6 | `/etc/vconsole.conf` | Sigue en `XKBLAYOUT=us` sin variante. Ponerlo con `localectl` haría que la TTY coincida con la sesión gráfica. ¿Merece la pena? |
| ⬜ | TEC-7 | `device { name = tpps/2-elan-trackpoint }` | TrackPoint del ThinkPad: `sensitivity = -0.5`, `accel_profile = adaptive`. Migra a `hl.device({...})`. Confirmar el nombre con `hyprctl devices`. |

## Bloque 2 — Bluetooth

Lo único de toda la config que es inequívocamente propio: conectar a auriculares
concretos por MAC con una tecla.

| St. | ID | Entrada | Qué hace | En quattro |
|---|---|---|---|---|
| ⬜ | BT-1 | Submap `bluetooth` (`SUPER+B`) | 6 dispositivos por MAC (Sony XM3/XM6, Bose, Bose QC Ultra, Pixel Buds Pro 2, barra de sonido), desconectar, toggle de micro | Omarchy tiene panel (`SUPER+CTRL+B`) pero no atajos por dispositivo. `hl.define_submap` existe. ¿Submap, o bindings sueltos sin submap? |
| ⬜ | BT-2 | `bin/.local/bin/bt` | Arranca el servicio, `rfkill unblock`, `bluetoothctl connect <MAC>` por alias | Funciona tal cual. ¿Simplificar con `omarchy-bluetooth-device`? |
| ⬜ | BT-3 | `bin/.local/bin/bt-toggle` | Alterna perfil A2DP ↔ HFP para usar el micro del auricular | Funciona (usa `pactl`), pero acaba en `pkill -RTMIN+10 i3blocks` — residuo muerto de la época de i3. ¿Existe equivalente en `omarchy-audio-*`? |
| ⬜ | BT-4 | Módulo `bluetooth` de waybar | Nombre del dispositivo + batería | `omarchy.bluetooth` ya está en `shell.json`. Comparar qué muestra. |

## Bloque 3 — Reglas de workspace

| St. | ID | Regla | Nota |
|---|---|---|---|
| ⬜ | WS-1 | Spotify → 10 | Instalado. |
| ⬜ | WS-2 | slack → 9 | **`slack` ya no está instalado.** ¿Se reinstala o se cae la regla? |
| ⬜ | WS-3 | ferdium → 9 | **`ferdium` ya no está instalado.** Idem. |
| ⬜ | WS-4 | `chrome-web.whatsapp.com__-Default` → 9 | La clase depende de cómo se lance el webapp; verificar que no cambió (ver Bloque 8). |
| ⬜ | WS-5 | teams-for-linux → 8 | Instalado. |
| ⬜ | WS-6 | zen → 5 | Instalado. |
| ⬜ | WS-7 | `chrome-web.telegram.org__-Default` → 3 | Igual que WS-4. |
| ⬜ | WS-8 | Reglas propias de Omarchy 4 | `default/hypr/apps/*.lua` trae reglas para 1password, pip, steam, qemu, jetbrains, telegram… Revisar si alguna choca. |

## Bloque 4 — La barra (waybar → omarchy-shell)

waybar era la barra de Omarchy 3: proyecto de terceros del ecosistema Hyprland,
configurada con JSONC + CSS. Quattro la sustituye por `omarchy-shell`, escrito
sobre **quickshell** (Qt/QML) y configurado en `~/.config/omarchy/shell.json`.
Otros autores, otro lenguaje, otro formato: no hay nada que "traducir".

`hyprland/.config/waybar/` **se borró el 2026-08-24** (BAR-12). El archivo es
`git show master:hyprland/.config/waybar/config.jsonc`, y este resumen existe
para no tener que ir a buscarlo.

### Lo que era mío de verdad

Comparado con el waybar de serie de Omarchy 3.8.5 (recuperado del clon viejo en
`~/.local/share/omarchy.…bak`, que conserva el git), esto es lo que había
cambiado. Todo lo demás era default y no cuenta como pérdida.

**Módulos añadidos** (no existían en el de serie):

| Módulo | Qué mostraba |
|---|---|
| `cpu` `memory` | Barritas de 8 niveles `▁▂▃▄▅▆▇█`, umbrales warning 70 / critical 90, clic → btop |
| `temperature` | `󰔏 {temperatureC}°`, warning 70 / critical 90, clic → btop |
| `disk` | `󰋊 {percentage_used}%` de `/`, tooltip `{used} / {total}` |
| `backlight` | Brillo en barritas de 8 niveles, scroll de 5 en 5 |
| `power-profiles-daemon` | Icono por perfil (performance / balanced / power-saver) |
| `mpris` | Artista – título **dentro del drawer del tray**, límites 30/20 caracteres |
| `hyprland/language` | `󰌌 US` / `󰌌 ES`, clic → cambiar layout (ver TEC-4/TEC-5) |
| `custom/dnd` | Script propio `dnd-status` (leía `makoctl mode`) + `dnd-toggle` |

**Módulos de serie que había retocado:**

- `cpu` de serie era un icono fijo; lo pasé a barritas con umbrales.
- `pulseaudio`: barritas de 8 niveles en vez de los 3 iconos de serie.
- `battery`: `{icon} {capacity}%` **siempre visible** (el de serie escondía el %),
  aviso al **33 %** en vez del 20 %, y tooltip con vatios `{power:>1.0f}W↓`.
- `bluetooth`: alias del dispositivo **y su batería en la propia barra**
  (`󰂱 {device_alias} {device_battery_percentage}%`); el de serie era solo un icono.
- `clock`: locale `en_GB.UTF-8`, formato `{:L%A %H:%M}`, tooltip con **calendario
  anual** (4 meses por columna), clic derecho → `cal -y` en terminal, clic central
  → timezone.
- En el CSS, lo único propio con significado: clases **`.warning`** (subrayado +
  negrita) y **`.critical`** (colores invertidos con padding). Eran el aviso
  visual de los umbrales de cpu/memoria/temperatura. El resto eran márgenes.

**Cosas de serie que había quitado:** el botón del logo (`custom/omarchy`) y los
`persistent-workspaces` 1–5.

### A decidir sobre la barra nueva

| St. | ID | Entrada | Nota |
|---|---|---|---|
| ⬜ | BAR-1 | workspaces, clock, weather, update, language, bluetooth, network, tray | Existen como `omarchy.*`. Comparar comportamiento, no presencia. |
| ⬜ | BAR-2 | `pulseaudio`, `backlight` | `omarchy.audio` / `omarchy.monitor`. Verificar scroll para volumen y brillo. |
| ⬜ | BAR-3 | **`cpu` `memory` `temperature` `disk` con barritas y umbrales** | **Sin equivalente en quattro.** Es la pérdida más grande del bloque y lo único que pedía un plugin propio de quickshell (`~/.config/omarchy/plugins` + `plugins: []`, regla 7). Antes de escribirlo: ¿se echan de menos de verdad, o basta `SUPER+CTRL+T` (btop)? Lo que de verdad se usaba puede haber sido solo el aviso `.critical`, no el número. |
| ⬜ | BAR-4 | `battery` con vatios y aviso al 33 % | `omarchy.power`. Comparar si muestra % siempre y si el umbral se configura. |
| ⬜ | BAR-5 | `power-profiles-daemon` | ¿Dentro de `omarchy.power`? Verificar. |
| ⬜ | BAR-6 | `mpris` (artista – título) | Sin equivalente visible. Existe `omarchy-shell media`. |
| ⬜ | BAR-7 | `group/tray-expander` (tray plegable) | `omarchy.tray` sin drawer. |
| ⬜ | BAR-8 | `custom/voxtype` | voxtype trae OSD propio (`voxtype-osd-gtk4`). Ver VOX-4. |
| ⬜ | BAR-9 | `custom/dnd` + los 3 indicadores | `omarchy.indicators` los agrupa. El script `dnd-status` murió con `makoctl` y se fue con el borrado. |
| ⬜ | BAR-10 | `clock` con calendario anual y locale `en_GB` | `omarchy.clock` (con `birthYear`/`lifeExpectancy`). ¿Se puede el calendario anual? |
| ⬜ | BAR-11 | Integración con el tema | Ver cómo tematiza omarchy-shell. |
| ✅ | BAR-12 | `hyprland/.config/waybar/` (3 ficheros) | **Borrado el 2026-08-24.** waybar desinstalada por el propio upgrade; mata también la trampa del restow que recreaba `~/.config/waybar`. |

## Bloque 5 — Dictado (voxtype) ✅⬜

### Por qué el dictado no se queda en los defaults (regla 10)

El estándar no cubre el caso, así que la regla 10 no aplica — es su excepción:

- **`SUPER+CTRL+X`**: es *toggle*, tres teclas, y el README de voxtype advierte
  de que los chords con varios modificadores en Hyprland pueden hacer que el
  texto tecleado dispare atajos del compositor al soltar despacio.
- **`F9`**: en este X1 Carbon Gen 12 la fila F manda las funciones especiales, así
  que hay que pasar por FnLock, y las teclas quedan tan separadas que obliga a
  usar las dos manos. Encima cambia de sitio al pasar al teclado externo.
- **`SUPER+SPACE`**: pulgar y pulgar, sin mover la mano, la izquierda sola — la
  derecha queda libre para el ratón. Es la acción que más se usa del día, así que
  se lleva el chord más cómodo del teclado.
- **La clase de tecla importa más que la tecla**: `SUPER`+letra y `SUPER+SPACE`
  viajan igual entre el portátil y el teclado externo (Super siempre pegado a la
  izquierda de Alt). La fila F no. Cualquier binding que se añada de aquí en
  adelante debería ser de la primera clase.
- **El coste del intercambio está medido**: al menú raíz solo se le quita el
  atajo alternativo a las apps. Al escribir en el menú raíz se cargan **todos**
  los providers, `apps` incluido (`loadProvidersForSearch` en el plugin
  `omarchy.menu`), así que buscar una app sigue saliendo desde ahí. Lo único que
  desaparece es *hojear* la lista completa de apps sin escribir nada.
- **Plan B si escuece** (sin deuda, solo un poco peor de dedos): dictado en
  `SUPER+A` o `SUPER+D` y el menú se queda donde Omarchy lo puso. De los 228
  defaults, con `SUPER` a secas están libres `Q E R A D Z B`.

**El servidor no está roto.** Verificado el 2026-08-23 de punta a punta:
`voxtype transcribe` contra `http://powerant:8080` devuelve texto en 0.49 s
(whisper.cpp server, alcanzable por Tailscale, `voxtype 0.7.5`, daemon
`voxtype.service` arriba desde el upgrade). Lo que se perdió es **el atajo**, no
la transcripción — y una cosa más que llevaba rota desde mayo (VOX-2).

| St. | ID | Entrada | Nota |
|---|---|---|---|
| ✅ | VOX-1 | `SUPER+SPACE` push-to-talk | **Se conserva**, y el menú de Omarchy se va a `SUPER+ALT+SPACE`. Rehecho en `bindings.lua` con `hl.unbind` + dos `o.bind` (el segundo con `{ release = true }`). `SUPER+CTRL+X` se deja intacto a propósito: queda como toggle para dictados largos. Primera excepción registrada a la regla 10, y el porqué está en el comentario del propio `bindings.lua`. |
| ✅🔍 | VOX-2 | `post_process` con `voxtype-clean-transcript` | **Estaba muerto desde el 2026-05-06 por dos agujeros de stow, no uno.** `~/.config/voxtype/` era un directorio real con un `config.toml` del 24 abril, así que el `post_process` que añadió `c10712d` nunca llegó al daemon; y `voxtype-clean-transcript` tampoco estaba en `~/.local/bin` (los otros 6 scripts de `bin/` sí), que es la razón de que la config apuntase al path del repo a pelo. Arreglado: `stow -R bin` y `~/.config/voxtype` → symlink al repo. El comando pasa a resolverse por `PATH` (`~/.local/bin` está en el PATH del daemon), así que deja de cablear `/home/alex`. Copia de la config vieja en el scratchpad de la sesión. |
| ⬜ | VOX-3 | `pause_media = true` | **Roto, y no es culpa nuestra.** El daemon avisa en cada grabación: `WARN playerctl not found or failed to run`. Corrige lo que decía este documento el 2026-08-23: voxtype **no** habla MPRIS directamente, llama a `playerctl` por fuera (`src/audio/media.rs`) y su propia ayuda dice *"Requires playerctl to be installed"*. Además `pause_media = true` **lo pone Omarchy 4 en su default** (`default/voxtype/config.toml:29`), y fue el propio `omarchy-upgrade-to-quattro` el que desinstaló `playerctl` el 2026-08-22 18:59, en la misma pasada que waybar, mako, swayosd y hypridle (`/var/log/pacman.log`). O sea: quattro envía la opción activada y quita la herramienta que la implementa. Opciones: instalar `playerctl` (repo `extra`, 81 KiB, solo depende de `glib2` y `glibc`; reabre también BND-5) o poner `pause_media = false`. Descartado un shim que traduzca a `omarchy-shell media`: habría que falsificar `-a`, `--player`, `status`… |
| ⬜ | VOX-4 | Indicador en la barra | `custom/voxtype` de waybar (ver BAR-8) puede sobrar: voxtype 0.7.5 trae su propio OSD (`voxtype-osd-gtk4`, corriendo ya). Ojo si se usa: `omarchy-voxtype-status` informa `Model: base.en, Backend: CPU (AVX2)` — lee los campos del modo local sin enterarse de que el modo es remoto, así que **miente sobre dónde se transcribe**. |

**🔍 Qué se está probando en VOX-1** (decidir hacia el 2026-08-30): si `F9` sale
natural para push-to-talk viniendo de `SUPER+SPACE`, y si `SUPER+CTRL+X` (toggle,
no hay que mantener pulsado) acaba gustando más para dictados largos. Si `F9`
molesta, el siguiente candidato estándar es dejar solo el toggle.

## Bloque 6 — Captura de pantalla

| St. | ID | Entrada | En quattro |
|---|---|---|---|
| ⬜ | CAP-1 | Submap `capture` (`SUPER+SHIFT+C`): editar, clipboard, grabar, color picker, share | Cubierto casi al completo: `SUPER+CTRL+C` (menú de captura), `PRINT`, `ALT+PRINT` (grabar), `SUPER+PRINT` (picker), `SUPER+CTRL+S` (share). Además `SUPER+SHIFT+C` es ahora Calendar. |
| ⬜ | CAP-2 | `SUPER+SHIFT+F` screenshot `smart copy` | En quattro `SUPER+SHIFT+F` es el gestor de archivos. |
| ⬜ | CAP-3 | `hypr/scripts/screencast-dnd` | Escucha DBus y activa DND al compartir pantalla, respetando el DND manual. **Roto**: usa `makoctl` y `bin/dnd-toggle`. Sustituto: `omarchy-toggle-notification-silencing`. Comprobar antes si Omarchy 4 ya lo hace solo. |
| ⬜ | CAP-4 | — | Nuevo y relevante aquí: `SUPER+CTRL+PRINT` extrae texto (OCR) de un screenshot, y durante la selección hay control por teclado (`RETURN` ventana, `TAB` siguiente). |

## Bloque 7 — Which-key y submaps restantes

**Decidir WK-1 primero**: si casi ningún submap sobrevive, el which-key entero
(daemon + eww + hoja de estilo) deja de tener sentido.

| St. | ID | Entrada | Nota |
|---|---|---|---|
| ⬜ | WK-1 | ¿Se sigue queriendo which-key? | Depende de cuántos submaps queden vivos tras BT-1, SUB-1, SUB-2, SUB-3 y CAP-1. |
| ⬜ | WK-2 | `eww/which-key-daemon.sh` | Escucha el evento `submap` por socket con `socat` y parsea `hyprctl binds`. Funciona, pero `hl.on("keybinds.submap", cb)` haría lo mismo sin socat ni awk. |
| ⬜ | WK-3 | Parseo de `hyprctl binds` | **Resuelto como hecho**: `-j` vuelve a dar JSON válido en 0.56.2 y 226/228 binds conservan `description`. El hack de `8acedd6` se puede tirar. |
| ⬜ | WK-4 | Color del borde del popup | Salía de `~/.config/omarchy/current/theme/swayosd.css`. swayosd no existe y la ruta del tema cambió a `~/.local/state/omarchy/current`. Buscar equivalente. |
| ⬜ | WK-5 | `eww/eww.yuck`, `eww/eww.scss` | Widget y estilos. Revisar tras WK-1. |
| ⬜ | SUB-1 | Submap `apps` (`SUPER+R`) | Spotify, Browser, Slack, Telegram, WhatsApp, Nautilus, btop, Docker, YouTube, Gemini. Todo salvo **Slack, Telegram y Gemini** existe ya como `SUPER+SHIFT+*`. Y Slack no está instalado. |
| ⬜ | SUB-2 | Submap `resize` (`SUPER+SHIFT+R`) | hjkl y flechas, pasos de 50px. Omarchy tiene resize directo en `SUPER+code:20/21` con tres granularidades (25/100/300). |
| ⬜ | SUB-3 | Submap `notifications` (`SUPER+COMMA`) | Cubierto al 100% de serie: `SUPER+comma` (última), `SUPER+SHIFT+comma` (todas), `SUPER+CTRL+comma` (silenciar), `SUPER+ALT+comma` (invocar), `SUPER+SHIFT+ALT+comma` (historial). Y `makoctl` no existe. Sin equivalente directo solo "dismiss group". |
| ⬜ | SUB-4 | Mecánica de los submaps | Cada binding hacía `hyprctl dispatch submap reset; comando`, más `catchall`/`ESCAPE`/`RETURN`. Si algún submap sobrevive, rehacer la mecánica con la API nueva en vez de traducirla. |

## Bloque 8 — Webapps

La migración regeneró los **3 lanzadores preinstalados de Omarchy** y se llevó
`env WEBAPP_CONTEXT=Personal` y los iconos propios. Los 10 webapps creados a
mano (ChatGPT, GitHub, Outlook, Gemini, Telegram, OneDrive…) están intactos.

| St. | ID | Entrada | Nota |
|---|---|---|---|
| ⬜ | WEB-1 | WhatsApp, YouTube, Google Photos `.desktop` | Perdieron `WEBAPP_CONTEXT=Personal` y el `Icon=` propio. |
| ⬜ | WEB-2 | Iconos | **Buena noticia**: los 12 PNG están versionados en `webapps/.local/share/applications/icons/`. Solo se renombró el directorio *vivo* a `.bak`; un restow los devuelve. |
| ⬜ | WEB-3 | Que Omarchy no los vuelva a pisar | Los 3 afectados son justo los preinstalados. ¿Renombrarlos? ¿`omarchy-webapp-remove` y recrearlos como propios? |
| ⬜ | WEB-4 | Integración open-in-zen | `WEBAPP_CONTEXT` + `bin/zen-open-url` + extensión en `webapps/.config/chromium-extensions/open-in-zen/` + `zen-open-handler.desktop`. ¿Sigue teniendo sentido con el `omarchy-launch-webapp` nuevo? Ver [webapps.md](webapps.md). |
| ⬜ | WEB-5 | `install-webapps.sh` | Comparar con `omarchy-webapp-install` / `omarchy-webapp-remove`. ¿Sigue haciendo falta? |

## Bloque 9 — Scripts propios

| St. | ID | Script | Estado |
|---|---|---|---|
| ⬜ | SCR-1 | `hyprland/.local/bin/hyprkeys` | **Irreparable, no solo roto.** Listaba bindings parseando `hyprctl -j binds`, pero con config Lua el comando ya no se expone (`dispatcher: __lua`). La información no existe. Sustituto: `omarchy-menu-keybindings` (`SUPER+K`). |
| ⬜ | SCR-2 | `bin/.local/bin/dnd-toggle` | Roto por triple: `makoctl`, `swayosd-client` y `pkill -RTMIN+9 waybar`. `omarchy-toggle-notification-silencing` hace lo mismo con su propio indicador. |
| ⬜ | SCR-3 | `hypr/scripts/screencast-dnd` | Ver CAP-3. |
| ⬜ | SCR-4 | `hypr/scripts/keyboard-layout-osd` | Ver TEC-4. |
| ⬜ | SCR-5 | `bin/.local/bin/zen-open-url` | Funciona. Ver WEB-4. |
| ⬜ | SCR-6 | `analyze_code`, `llm_spend`, `voxtype-clean-transcript` | Sin relación con Omarchy. Solo verificar que siguen funcionando. |

## Bloque 10 — Bindings sueltos

Omarchy 4 trae **228 bindings de serie** (Omarchy 3 traía una fracción). Antes
de migrar cualquiera, mirar si ya existe.

### 10a — Idénticos al default: solo confirmar y borrar

`SUPER+RETURN` terminal · `SUPER+ALT+RETURN` tmux · `SUPER+SHIFT+RETURN` y
`SUPER+SHIFT+B` browser · `SUPER+SHIFT+ALT+B` browser privado · `SUPER+SHIFT+M`
Spotify · `SUPER+SHIFT+ALT+M` cliamp · `SUPER+SHIFT+N` editor · `SUPER+SHIFT+D`
lazydocker · `SUPER+SHIFT+G` Signal · `SUPER+SHIFT+A` ChatGPT ·
`SUPER+SHIFT+ALT+A` Grok · `SUPER+SHIFT+E` email · `SUPER+SHIFT+Y` YouTube ·
`SUPER+SHIFT+ALT+G` WhatsApp · `SUPER+SHIFT+CTRL+G` Google Messages ·
`SUPER+SHIFT+X` X · `SUPER+SHIFT+ALT+X` X Post · más las líneas comentadas de
Obsidian y Google Photos, que ahora existen de serie.

| St. | ID | Entrada |
|---|---|---|
| ⬜ | BND-1 | Confirmar uno a uno que el default hace lo mismo (ojo `SUPER+ALT+RETURN`: el propio pasaba `--dir` con `omarchy-cmd-terminal-cwd`) y borrarlos |

### 10b — Chocan con un default de quattro

| St. | ID | Tecla | Era | Ahora es |
|---|---|---|---|---|
| ✅ | BND-2 | `SUPER+SPACE` | Dictado voxtype | **Se recupera para el dictado**; el menú a `SUPER+ALT+SPACE`. Ver VOX-1. |
| ⬜ | BND-3 | `SUPER+D` | Lanzador (walker) | Libre. walker no existe; el menú es `SUPER+SPACE` y las apps `SUPER+ALT+SPACE`. |
| ⬜ | BND-4 | `SUPER+W` / `SUPER+SHIFT+Q` | Pop window out / cerrar ventana | `SUPER+W` cierra ventana, `SUPER+O` es pop-out. |
| ⬜ | BND-5 | `SUPER+I` / `SUPER+O` / `SUPER+P` | Spotify: anterior / play-pause / siguiente | `SUPER+O` pop-out, `SUPER+P` pseudo. **`playerctl` no está instalado**; quattro usa `omarchy-shell media next\|playPause\|previous` sobre las teclas `XF86Audio*`. Ojo: lo propio era específico de Spotify (`--player=spotify`), lo nuevo va al reproductor activo.  Depende de VOX-3: si se instala `playerctl`, los atajos propios vuelven a ser posibles. |
| ⬜ | BND-6 | `SUPER+SHIFT+I/O/P` | Multimedia genérico | `SUPER+SHIFT+O` Obsidian, `SUPER+SHIFT+P` Google Photos. |
| ⬜ | BND-7 | `SUPER+X` | Foco a ventana urgente | **Cortar universal** (`SUPER+C/V/X` funcionan también en terminales y paneles). ¿Se usaba de verdad "ventana urgente"? |
| ⬜ | BND-8 | `SUPER+SHIFT+code:61` | Menú de keybindings | `SUPER+SHIFT+SLASH` es 1Password; el menú de keybindings es `SUPER+K`. |
| ⬜ | BND-9 | `SUPER+CTRL+P` | Toggle pseudo | Panel de energía. Pseudo está en `SUPER+P`. |
| ⬜ | BND-10 | `SUPER+SHIFT+W` | Typora | **`typora` no está instalado**; quattro pone ahí Omawrite. ¿Reinstalar, probar Omawrite, o nvim y a otra cosa? |
| ⬜ | BND-11 | `SUPER+SHIFT+T` | btop | Libre; quattro usa `SUPER+CTRL+T`. |
| ✅ | BND-12 | `unbind SUPER+CTRL+X` | Se desbindeaba por peligroso en Omarchy 3 | Ahora es el toggle de dictado y se quiere: el `unbind` viejo se fue y el default se deja en paz. |

### 10c — Propios sin equivalente

| St. | ID | Binding | Nota |
|---|---|---|---|
| ⏭️ | BND-13 | `SUPER+H/J/K/L` foco y `SUPER+SHIFT+H/J/K/L` mover ventana | **Descartado 2026-08-23**: "no me importa, no lo uso mucho". Se borran sin sustituto; quedan los defaults con flechas. |
| ⬜ | BND-14 | `SUPER+N` workspace vacío | Quattro tiene `SUPER+TAB` / `SUPER+SHIFT+TAB` para navegar. |
| ⬜ | BND-15 | `SUPER+apostrophe` / `SUPER+SHIFT+apostrophe` | Último workspace / mover al último (costumbre de i3). Quattro: `SUPER+CTRL+TAB`. |
| ⬜ | BND-16 | `SUPER+BACKSLASH` toggle split | Quattro lo pone en `SUPER+J`. |
| ⬜ | BND-17 | `SUPER+Q` cambiar layout | Ver TEC-4. |

## Bloque 11 — Monitores, aspecto y autostart

Baja prioridad por decisión explícita ("los monitores dan igual"), pero MON-2
tiene una trampa: en cuanto se enchufe el LG vuelven las rayas.

| St. | ID | Entrada | Nota |
|---|---|---|---|
| ⬜ | MON-1 | `GDK_SCALE=1` + `monitor=,preferred,auto,1` | La plantilla nueva ya trae exactamente esto. |
| ⬜ | MON-2 | Override del LG UltraGear a `2560x1440@120` | **Workaround temporal**: a 4K por HDMI salen rayas negras (fallo del panel; aparece hasta en el OSD del monitor). No depende de Omarchy, sigue aplicando. ¿Llegó ya el hub USB-C → DisplayPort? |
| ⬜ | MON-3 | ARZOPA portátil en `auto-left` | Siempre a la izquierda del portátil. Comprobar que `position = "auto-left"` funciona en `hl.monitor{}`. |
| ⬜ | MON-4 | `decoration.rounding = 8` (`looknfeel.conf`) | Lo único que hacía ese fichero; el resto eran comentarios. |
| ⬜ | AUT-1 | `exec-once = hyprsunset` | **Ya no hace falta**: `hyprsunset` está corriendo sin que lo lance nada propio, lo arranca Omarchy. Además hay toggle de nightlight en `SUPER+CTRL+N`. |
| ⬜ | AUT-2 | `exec-once = eww daemon` + `which-key-daemon.sh` | Depende del Bloque 7. |
| ⬜ | AUT-3 | `exec-once = screencast-dnd` | Ver CAP-3. |
| ⬜ | INP-1 | Gestos de touchpad de 3 dedos | Estaban comentados, nunca activados. Quattro documenta `hl.gesture{}` con acciones por dirección. ¿Ahora sí? |

## Bloque 12 — Idle y lock

| St. | ID | Entrada | Nota |
|---|---|---|---|
| ⬜ | IDLE-1 | Screensaver a 150s | `shell.json` ya tiene `"idle": { "screensaver": 150 }`. **Coincide**. |
| ⬜ | IDLE-2 | Lock a 152s | `shell.json` tiene `"lock": 300`. El 152 era un truco ("mitad + 2s de margen") porque el screensaver reseteaba el timer; ese hack ya no hace falta. ¿300 vale? |
| ⬜ | IDLE-3 | `hypridle.conf` entero | `lock_cmd`, `before_sleep_cmd`, `after_sleep_cmd`, `inhibit_sleep`. Nativo en quattro (`omarchy-system-sleep-lock`, `omarchy-system-sleep-monitor`). **`hypridle` no está instalado.** Verificar suspender/despertar antes de borrarlo. |
| ⬜ | IDLE-4 | `hyprlock.conf` | Estilo del lock: input field, JetBrainsMono, blur del fondo, huella deshabilitada. **`hyprlock` no está instalado.** ¿Se puede personalizar el nuevo? ¿Y la huella? |
| ⬜ | IDLE-5 | `omarchy-toggle-idle` | Nuevo: `SUPER+CTRL+I`. |

## Bloque 13 — Limpieza del repo

| St. | ID | Fichero | Nota |
|---|---|---|---|
| ⬜ | REP-1 | `hypr/hyprland.conf` | Ya no lo lee nadie. Borrar cuando los bloques 1–11 hayan vaciado los `.conf`. |
| ⬜ | REP-2 | `hypr/hypridle.conf`, `hypr/hyprlock.conf` | Ver IDLE-3, IDLE-4. |
| ⬜ | REP-3 | `hypr/hyprsunset.conf` | **Sigue vivo y sigue siendo `.conf` en quattro.** Solo verificar. |
| ⬜ | REP-4 | `hypr/xdph.conf` | Sigue vivo (`allow_token_by_default`, `custom_picker_binary`). Comparar con el default de quattro. |
| ⬜ | REP-5 | `hypr/.luarc.json` | Lo puso la migración; apunta a los stubs. Confirmar que se quiere versionado. |
| ⬜ | REP-6 | **`i3/` (44 ficheros)** | i3, i3blocks y polybar desinstalados; último toque hace 7 meses. **Borrado ya autorizado (2026-08-23)**, pendiente de ejecutar. |
| ⬜ | REP-7 | `install-hyprland.sh` | Instala `hypridle`, `hyprlock`, `waybar`, `mako`, `swayosd-git` y clona omarchy a mano. Obsoleto de arriba abajo. ¿Reescribir o borrar? |
| ⬜ | REP-8 | `docs/hyprland.md` | Describe la arquitectura de Omarchy 3 (waybar, mako, rutas viejas). Reescribir al terminar. |
| ⬜ | REP-9 | `docs/which-key.md` | Rutas de tema viejas y `swayosd.css`. Depende del Bloque 7. |
| ⬜ | REP-10 | `docs/webapps.md` | Verificar contra el Bloque 8. |
| ⬜ | REP-11 | `CLAUDE.md` | La regla "NEVER modify `~/.local/share/omarchy/`" hay que actualizarla: ahora es `/usr/share/omarchy`, es un paquete pacman, y `~/.local/share/omarchy` es un symlink de compatibilidad. |

---

## Anexo A — Cosas nuevas de quattro (no son tareas)

Material de consulta, no lista de pendientes. Está aquí porque no se puede
decidir sobre el submap de captura sin saber que `SUPER+CTRL+C` existe.

| Feature | Qué es |
|---|---|
| `SUPER+C/V/X` | Portapapeles universal: funciona también en terminales (traduce a `CTRL+INSERT`/`SHIFT+INSERT`) y en paneles |
| `SUPER+L` | Alterna layout tiling ↔ **scrolling** (lateral, tipo niri) |
| `SUPER+CTRL+{A,B,D,W,P}` | Paneles de audio / bluetooth / display / red / energía |
| `SUPER+CTRL+code:1..9` | Abrir el panel N de la sección derecha de la barra |
| `SUPER+CTRL+R` | Recordatorios (`omarchy-reminder`) |
| `SUPER+CTRL+PRINT` | OCR: extraer texto de un screenshot |
| `SUPER+CTRL+Q` | Calculadora (`omacalc`) |
| `SUPER+CTRL+Z` | Zoom de pantalla |
| `SUPER+SHIFT+CTRL+A` | Agentes (`omarchy-agent --pick`) + módulo `omarchy.agents` |
| `SUPER+K` | Menú de keybindings (sustituye a `hyprkeys`) |
| `SUPER+CTRL+RETURN` | `herdr` — averiguar qué es |
| `SUPER+ESCAPE` | Menú de sistema |
| Captura por teclado | Al seleccionar región: `RETURN` ventana, `TAB` siguiente, flechas |
| `omarchy.tailscale` | Módulo de barra para Tailscale |
| Toggles | `SUPER+CTRL+I` idle · `SUPER+CTRL+N` nightlight · `SUPER+SHIFT+SPACE` barra · `SUPER+BACKSPACE` transparencia · `SUPER+SHIFT+BACKSPACE` gaps |

## Anexo B — La cola: probablemente nunca

Con la regla 9 (esto acaba cuando el escritorio se siente mío), lo honesto es
decir que esto seguramente no se mire. Está escrito para saber **dónde se está
aceptando riesgo**, no para fingir que son tareas. Si alguna vez importa, sube
de bloque.

Backups que dejó la migración, por si alguno tenía algo propio dentro:
`chromium-flags.conf` (permisos 600, el más sospechoso) · `brave-flags.conf` ·
`mimeapps.list` (asociaciones de tipo de fichero) · `xdg-terminals.list` ·
`uwsm/env` y `uwsm/default` · `environment.d/fcitx.conf` · `fontconfig/fonts.conf` ·
`fastfetch/config.jsonc` · `imv/config` · `xournalpp/settings.xml` ·
`hyprland-preview-share-picker/config.yaml` · `walker/`, `mako/`, `swayosd/` ·
`~/.local/share/omarchy.…bak` (el clone viejo entero — mirar si tenía parches
locales antes de borrarlo).

Verificaciones sin problema conocido: nvim (quattro trae paquete `omarchy-nvim`
y el repo stowea su propio LazyVim — comprobar que no colisionan) ·
`remote_clipboard.lua` (OSC 52 para tmux/SSH) · el tema actual, cuya ruta cambió
a `~/.local/state/omarchy/current/theme` · `githooks/post-merge` ·
`pacman/.config/pacman/makepkg.conf`.

---

## Registro de decisiones

| Fecha | ID | Decisión | Motivo |
|---|---|---|---|
| 2026-08-22 | — | Snapshot en rama `quattro`, `master` intacto | Poder volver al Omarchy 3 funcionando mientras se migra sin prisa |
| 2026-08-23 | — | Sin sesgo por defecto (regla 3) | Cualquier sesgo cortocircuita el objetivo: "bórralo, ya hay algo parecido" y "tradúcelo y a otra cosa" llevan igual de rápido a dejar de mirar la entrada |
| 2026-08-23 | — | Perímetro: lo que quattro rompió, más `hyprland/` entero | Mezclar la limpieza general del repo hace imposible saber cuándo se ha terminado |
| 2026-08-23 | — | Features nuevas como anexo, no como tareas (Anexo A) | Hacen falta para decidir, pero si son tareas entonces "probar el layout scrolling una semana" bloquea la migración |
| 2026-08-23 | — | Se permite prueba de campo (🔍) con qué y cuándo escritos | La ergonomía no se decide sentado; el "cuándo" evita que 🔍 sea un cajón |
| 2026-08-23 | — | Escribir código nuevo entra en el perímetro | Si no, entradas como "quiero cpu en la barra" no se pueden cerrar y quedan de ⬜ eternas |
| 2026-08-23 | — | La lista se ordena por impacto y la cola se marca como tal | Si lo que no se revisa se abandona, el orden **es** la decisión de qué no se hace |
| 2026-08-23 | — | Documento en español, commits en inglés | El documento es donde se piensa; los commits conviven con el historial existente |
| 2026-08-23 | TEC-1 | Teclado: `us` + `altgr-intl` + `ctrl:nocaps,compose:rctrl,shift:both_capslock_cancel` | Única opción que da español directo **y** Caps=Ctrl **y** comillas normales para código, sin cambiar de layout. Ctrl derecho no se usaba, así que aloja Compose |
| 2026-08-23 | BND-13 | Navegación vim (`SUPER+H/J/K/L`) descartada | "No me importa, no lo uso mucho" |
| 2026-08-23 | MON-* | Monitores a baja prioridad | "Los monitores dan igual" — solo está conectado el portátil |
| 2026-08-23 | REP-6 | Borrar `i3/` autorizado | i3, i3blocks y polybar desinstalados; sin tocar desde enero |
| 2026-08-23 | — | Regla 10: atajos lo más estándar posible | Cada binding propio hay que revisarlo en cada upgrade y puede chocar con un default nuevo; esta migración es la factura de no haberlo hecho así. No aplica al teclado (TEC-1), que no es un atajo de Omarchy |
| 2026-08-23 | VOX-2 | Todo lo configurable va stowed y enlazado al repo, sin excepciones | Se usa en varias máquinas: lo que no está enlazado se queda en un solo ordenador y deriva en silencio. Esta entrada llevaba 4 meses derivada sin que nadie lo notase |
| 2026-08-23 | VOX-1 | Dictado push-to-talk en `SUPER+SPACE`; menú de Omarchy a `SUPER+ALT+SPACE`; `SUPER+CTRL+X` intacto como toggle | Excepción a la regla 10 porque el estándar no cubre el caso: `F9` exige FnLock y dos manos, y `SUPER+CTRL+X` es un toggle de tres teclas. La acción más usada se lleva el chord más cómodo, y el menú solo pierde el atajo a las apps, que ya se buscan desde la raíz |
