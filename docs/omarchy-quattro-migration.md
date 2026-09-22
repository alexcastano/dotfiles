# Migración a Omarchy quattro

> **Terminada el 2026-09-21.** Queda como archivo: el *por qué* de cada decisión
> de `hyprland/` está aquí y en ningún otro sitio. Lo que sigue abierto son
> cuatro entradas que ya no son migración (ver [Estado final](#estado-final)).
>
> Si vuelves a abrirlo para decidir algo, **lee "Cómo trabajamos" primero**: las
> reglas siguen valiendo.

- **Rama**: `quattro` · **Rollback**: `master` (último Omarchy 3 funcionando)
- **Punto de partida**: snapshot del working tree tras `omarchy-upgrade-to-quattro` (2026-08-22)
- **Versiones**: Omarchy 4.0.0.alpha · Hyprland 0.56.2

---

## Estado final

La migración se da por terminada el **2026-09-21**, con la regla 9 cumplida por
el lado bueno: no se abandonó nada por cansancio, simplemente se acabó la lista.

**Los 13 bloques están cerrados.** De las ~70 entradas del inventario, el
reparto real fue: la mayoría se resolvieron **adoptando el default de quattro**,
un puñado se restauraron porque no había equivalente, y exactamente **una añadió
algo nuevo** (INP-1, los gestos).

Lo que sobrevive como propio en `hyprland/` cabe en una lista:

- El teclado (`input.lua`) — y está en revisión, ver TEC-2
- El gesto de tres dedos (`input.lua`), que es el default de Hyprland descomentado
- Dos bindings (`bindings.lua`): dictado en `SUPER+SPACE` y `SUPER+N`
- Las reglas de escritorio (`windowrules.lua`)
- `screencast-dnd` + su autostart
- `nightlight-toggle` y `hyprsunset.conf`
- La config de voxtype

Todo lo demás es el default de Omarchy. `looknfeel.lua` y `monitors.lua` son la
plantilla de quattro sin una sola línea propia.

### Lo que sigue abierto, y por qué no es migración

| Entrada | Qué es ahora |
|---|---|
| TEC-2 | Reabre TEC-1: "el altgr no me acaba de convencer, vamos a volver a lo que teníamos". Es una decisión de teclado nueva, con su propia investigación ya escrita arriba |
| VOX-7 | Consecuencia de TEC-1. Se decide cuando se decida el teclado |
| VOX-8 | Dos fallos latentes documentados a propósito para no diagnosticarlos dos veces. No se arreglan |
| SUN-1 | Bloqueada por REP-12, que está aparcada por decisión explícita |

### Deuda aceptada por escrito

1. **REP-12**: `~/.config/omarchy/` (hooks y `shell.json`, o sea toda la barra)
   sigue sin versionar. Es la única grieta viva del "todo va stowed", y ya costó
   ocho meses de deriva silenciosa una vez.
2. **REP-7**: al borrar `install-hyprland.sh`, los tres pasos manuales que
   necesita una máquina nueva para el dictado (`pacman -S dotool`,
   `usermod -aG input $USER`, volver a iniciar sesión) solo viven escritos aquí
   y en `docs/hyprland.md`. Nada los ejecuta.
3. **VOX-6 en esta máquina**: el grupo `input` no está aplicado, así que dotool
   cae a `wtype`. El dictado funciona en todo menos en los acentos dentro de
   Electron. Se deja a sabiendas.

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

11. **Antes de decidir sobre algo que quattro rompió, mirar si ya está
    reportado.** `gh search issues --repo basecamp/omarchy <término>` y lo mismo
    con `gh search prs`. Cuesta un minuto y cambia la pregunta: si upstream ya lo
    tiene diagnosticado y con arreglo en camino, la decisión no es "¿qué hago con
    esto?" sino "¿me pongo un puente y espero?" — que es una decisión distinta y
    normalmente mejor. Y si hay puente, se apunta **con su condición de salida**,
    para que no se quede instalado a mano para siempre (ver VOX-3 y VOX-5).
    Además evita reescribir una investigación que ya está hecha y confirmada por
    varias personas.

**Idioma**: este documento en español (es donde se piensan las decisiones), los
commits en inglés como el resto del repo.

**Estados**: ⬜ pendiente · 🔍 en prueba de campo · ✅ decidido y hecho · ⏭️ descartado · ⏸️ aparcada a propósito (con motivo escrito)

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

## Bloque 1 — Teclado ✅🔍 (reabierto 2026-09-21)

| St. | ID | Entrada | Notas |
|---|---|---|---|
| ✅ | TEC-1 | `us` + `altgr-intl` + `ctrl:nocaps,compose:rctrl,shift:both_capslock_cancel` | Aplicado en `input.lua`. Ver la investigación arriba. |
| ⏭️ | TEC-2 | Prueba de campo de TEC-1 | **Cerrada en contra (2026-09-21).** El Alt derecho no se echó de menos, pero `AltGr+vocal` nunca llegó a salir natural: "ha sido un precioso experimento pero no he llegado a acostumbrarme nunca del todo". Continúa en TEC-8. |
| ✅ | TEC-3 | `repeat_delay = 600` | **Default 250 (2026-09-21).** `input.conf` llevaba muerto desde el 22 de agosto, así que el 250 ya se estaba viviendo un mes sin queja: la prueba de campo se hizo sola. Era inercia, no intención. |
| ✅ | TEC-4 | `SUPER+Q` cambiar layout + `keyboard-layout-osd` | **Borrados (2026-09-21).** Con un solo layout no hay nada que alternar, y el script hablaba con `swayosd-client`, desinstalado. El binding ya se había ido con BND-17. |
| ⏸️ | TEC-5 | Módulo `omarchy.keyboard-layout` en `shell.json` | **Aparcada (2026-09-21)**, junto con TEC-6: depende de si se vuelve al layout anterior. Además vive en `shell.json`, bloqueado por REP-12. |
| ⏸️ | TEC-6 | `/etc/vconsole.conf` | **Aparcada (2026-09-21).** "Esto del altgr no me acaba de convencer, creo que vamos a volver a lo que teníamos antes." Alinear la TTY con un layout que puede cambiar sería trabajo tirado; se decide cuando se decida TEC-1. |
| 🔍 | TEC-8 | **Prueba: `us(intl)` en vez de `us(altgr-intl)`** (2026-09-21) | "El altgr no me convence, a veces no escribo el acento en la letra que toca." Se prueba la variante con **teclas muertas**: `'`+a = á, sin mantener ningún modificador — el mismo gesto que el layout `es` de siempre, pero sin cambiar de layout. `AltGr+a` y `AltGr+n` siguen funcionando. **Coste**: `' " ` ~` pasan a ser teclas muertas (literal con AltGr+tecla o tecla+espacio), que es exactamente lo que descartó `us(intl)` en TEC-1 por "infierno para escribir código" — **esto es lo que hay que medir esta vez**, escribiendo código de verdad. Verificado que `RALT` sigue siendo `ISO_Level3_Shift`, así que los `MOD5+code:16/17/18` de multimedia no se tocan. Arrastra `dotool_xkb_variant = "intl"` en `voxtype/config.toml` (si no, los acentos del dictado vuelven a romperse en Slack, VOX-6). **Qué se decide**: si las comillas muertas se pueden vivir escribiendo código, y si el acento cae donde toca. Revisar ~2026-09-28 |
| ⬜ | TEC-9 | Diagnóstico del fallo real de TEC-2 | Tres causas posibles y solo dos las arregla la disposición: (1) se pierde el acento (rollover, AltGr no registra), (2) se acentúa la letra siguiente (AltGr soltado tarde), (3) el acento se decide **después** de escribir la vocal — esta última no la arregla ni `intl` ni `es`, porque en los dos el acento va antes. Anotar cuál es al vivir TEC-8. **Pista encontrada al aplicar TEC-8 (2026-09-21)**: hay un `fcitx5` corriendo (PID vivo, `--disable notificationitem`) y su teclado virtual sale como `main: True` en `hyprctl devices` — y es el **único** que se quedó en `altgr-intl` tras el `hyprctl reload`; los nueve físicos pasaron a `intl`. Un teclado virtual sube su propio keymap y no sigue a `input.lua`. Si algún método de entrada está pasando por ahí, el layout efectivo no era el que creíamos. Sin verificar: hace falta probar escribiendo |
| ✅ | TEC-7 | `device { name = tpps/2-elan-trackpoint }` | **Default (2026-09-21).** Mismo razonamiento que TEC-3: un mes con el TrackPoint a sensibilidad normal sin echarlo de menos. No se porta a `hl.device{}`. |

## Bloque 2 — Bluetooth ⏭️✅

**Cerrado el 2026-08-28.** Era el bloque señalado como "lo único inequívocamente
propio", y resultó ser el más barato de todos: el panel de Omarchy (`SUPER+CTRL+B`)
cubre el caso de uso real. Los atajos por MAC llevaban **seis días sin existir**
(las `.conf` dejaron de leerse el 22 de agosto) y no se echaron de menos — la
prueba de campo se hizo sola.

Los dos scripts se quedan: son comandos de un disparo, sin demonio ni coste por
tenerlos, y `bt-toggle` no tiene sustituto en quattro.

| St. | ID | Entrada | Decisión |
|---|---|---|---|
| ⏭️ | BT-1 | Submap `bluetooth` (`SUPER+B`) | **Descartado.** 6 dispositivos por MAC + desconectar + toggle de micro. `SUPER+B` estaba libre y `hl.define_submap` existía, así que era migrable — pero el panel de serie basta. `submaps/bluetooth.conf` borrado y su `source =` fuera de `submaps.conf`. Archivo: `git show master:hyprland/.config/hypr/submaps/bluetooth.conf`. **Arrastra a WK-1.** |
| ✅ | BT-2 | `bin/.local/bin/bt` | **Se queda.** Arranca el servicio, `rfkill unblock`, `bluetoothctl connect <MAC>` por alias. Se conserva "por si acaso": ya no lo llama ningún binding, pero desde la terminal sigue valiendo. Sustituto de Omarchy si algún día se quiere simplificar: `omarchy-bluetooth-device connect <MAC>`, que hace lo mismo mejor (enciende vía `omarchy-bluetooth-power`, que sí levanta el rfkill soft block — `bluetoothctl power on` a secas falla ahí —, además de `trust` y `timeout 20s`). Tenía un `pkill -RTMIN+10 i3blocks` muerto al final; **eliminado el 2026-08-28** al borrar `i3/` (REP-6), rectificando la decisión previa de no tocar el script. |
| ✅ | BT-3 | `bin/.local/bin/bt-toggle` | **Se queda.** Alterna el perfil de la tarjeta A2DP ↔ HFP para usar el micro del auricular. **No hay equivalente en quattro**: los `omarchy-audio-*` son sink/source/volumen/mute, ninguno toca el perfil de la tarjeta. Único cambio: fuera el `pkill -RTMIN+10 i3blocks` del final. |
| ⏭️ | BT-4 | Módulo `bluetooth` de waybar | **Sin objeto.** waybar se borró en BAR-12; `omarchy.bluetooth` ya está en `shell.json` y el usuario lo da por bueno. |

**Nada que desinstalar.** `bt` y `bt-toggle` son scripts de un disparo, no
demonios. Los demonios de la época vieja (`waybar`, `mako`, `swayosd`,
`hypridle`, `hyprlock`, `walker`, `i3`, `i3blocks`, `polybar`) ya los desinstaló
`omarchy-upgrade-to-quattro`; ninguno corre. Comprobado el 2026-08-28.

## Bloque 3 — Reglas de workspace

| St. | ID | Regla | Nota |
|---|---|---|---|
| ✅ | WS-1 | Spotify → 10 | **Restaurada.** Paquete `spotify` instalado, clase `Spotify` verificada en vivo. |
| ✅ | WS-2 | slack → 9 | **Restaurada.** El aviso de "ya no está instalado" era un error de comprobación: el paquete se llama **`slack-desktop`**, no `slack`. Está instalado, corriendo, y su clase es `slack`. |
| ⏭️ | WS-3 | ferdium → 9 | **Descartada.** `ferdium` no está instalado y no vuelve. El hueco de mensajería en el 9 ya lo llenan Slack y WhatsApp. |
| ✅ | WS-4 | `chrome-web.whatsapp.com__-Default` → 9 | **Restaurada.** Clase verificada en vivo, sin cambios. `WEBAPP_CONTEXT=Personal` no toca el perfil de Chromium (solo lo lee `zen-open-url`), así que el sufijo sigue siendo `-Default`. |
| ✅ | WS-5 | teams-for-linux → 8 | **Restaurada.** Instalado; clase sin verificar en vivo (no estaba abierto), pero es el nombre del binario/paquete y no cambió en quattro. |
| ✅ | WS-6 | zen → 5 | **Restaurada.** `zen-browser-bin` instalado, clase `zen` verificada en vivo. |
| ✅ | WS-7 | `chrome-web.telegram.org__-Default` → 3 | **Restaurada.** Clase verificada en vivo. Mismo razonamiento que WS-4. |
| ✅ | WS-8 | Reglas propias de Omarchy 4 | **Sin colisiones.** Repasados los 19 ficheros de `/usr/share/omarchy/default/hypr/apps/`: la única regla de `workspace` de serie es `title = ".*is sharing.*"` → `special silent` (browser.lua). `telegram.lua` afecta al Telegram **nativo** (`org.telegram.desktop`), no al webapp. Los `tag` de `browser.lua` sí alcanzan a `zen` y a los webapps, pero solo aplican opacidad. |

**Por qué se habían "perdido".** No las borró la migración: `windowrules.conf`
seguía intacto en el repo, pero **muerto**. Quattro arranca por
`hyprland.lua` (`hyprctl systeminfo` → `configProvider: lua`), y su lista de
`require` no incluía las reglas; el `source =` que las cargaba vivía en
`hyprland.conf`, que ya no lo lee nadie (REP-1). Las apps que parecían estar en
su sitio estaban colocadas a mano.

**Cómo quedan (2026-08-29).** Fichero nuevo `hypr/windowrules.lua` con
`require("hypr.windowrules")` en `hyprland.lua`, en línea con los otros cinco
módulos. La traducción es directa vía el helper de Omarchy:

```lua
o.window("Spotify", { workspace = "10 silent" })
```

`silent` se conserva tal cual dentro de la cadena — es el mismo patrón que usa
Omarchy de serie en `default/hypr/apps/browser.lua`. `windowrules.conf`
borrado, más su `source =` en `hyprland.conf` (regla 8). Archivo:
`git show master:hyprland/.config/hypr/windowrules.conf`. **Bloque cerrado.**

## Bloque 4 — La barra (waybar → omarchy-shell) ✅ CERRADO

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

### Lo que hay ahora (2026-08-30)

`~/.config/omarchy/shell.json`, comparado con el default de quattro
(`/usr/share/omarchy/config/omarchy/shell.json`):

```
izq:    menu · workspaces
centro: indicators · clock · keyboard-layout · system-update · weather · timezones*
dcha:   tray · notification-center* · tailscale · agents · bluetooth · network ·
        audio · monitor · power
```

`*` = plugins de terceros instalados en `~/.config/omarchy/plugins/`:
`io.github.sspaeti.timezones` (reloj mundial con rejilla horaria) y
`shavanced.notification-center` (historial de notificaciones + DND). Ambos se
declaran *theme-aware* en su manifest.

Sobre el default se ha añadido: los dos plugins, `omarchy.tailscale`, y el
`clock` con formato propio (`ddd d MMM HH:mm`) más `birthYear` / `lifeExpectancy`.

**Ojo — no está stowed.** `shell.json` y `plugins/` son ficheros reales bajo
`~/.config/omarchy/`, no symlinks al repo. Ver el bloque de stow.

### Catálogo de widgets de quattro

Registrados por `shell/services/BarWidgetRegistry.qml`. En uso los de arriba;
**disponibles y sin usar**: `omarchy.media`, `omarchy.active-window`,
`omarchy.microphone`, `omarchy.spacer`, `omarchy.wifiqr`, `omarchy.dropbox`,
`omarchy.speedtest`, `omarchy.disk-speedtest`, `omarchy.battery`,
`omarchy.nightlight`, `omarchy.reminders`.

`omarchy.indicators` **agrupa** los indicadores de
`shell/plugins/bar/indicators/`: `Dictation`, `Dnd`, `NightLight`, `Reminder`,
`ScreenRecording` y `StayAwake`.

### Decisión

| St. | ID | Entrada | Nota |
|---|---|---|---|
| ✅ | BAR-1 | workspaces, clock, weather, update, language, bluetooth, network, tray | Todos puestos y en uso diario. |
| ✅ | BAR-2 | `pulseaudio`, `backlight` | `omarchy.audio` y `omarchy.monitor` puestos. El scroll no se verificó en banco: se da por bueno por uso. |
| ⏸️ | BAR-3 | **`cpu` `memory` `temperature` `disk` con barritas y umbrales** | **La única pérdida real del bloque.** No hay equivalente: `omarchy.disk-speedtest` mide velocidad, no % de uso. Aparcada porque en 6 días de uso no se ha echado de menos. Si se revisita, la pregunta sigue siendo "¿usaba el número, o solo el aviso `.critical`?" — lo segundo es mucho más barato (plugin mínimo de quickshell en `~/.config/omarchy/plugins`). |
| ✅ | BAR-4 | `battery` con vatios y aviso al 33 % | Dentro de `omarchy.power` (hay además `omarchy.battery` suelto sin usar). El umbral propio del 33 % no se ha reproducido y no se ha echado de menos. |
| ✅ | BAR-5 | `power-profiles-daemon` | Cubierto por `omarchy.power`. |
| ✅ | BAR-6 | `mpris` (artista – título) | **Corrige lo que decía este documento**: sí hay equivalente, `omarchy.media` (`shell/plugins/services/media/BarWidget.qml`). Se deja **sin poner** por decisión: no se ha echado de menos. Recuperable con una línea en `shell.json`. |
| ✅ | BAR-7 | `group/tray-expander` (tray plegable) | `omarchy.tray` sin drawer. Se acepta. |
| ✅ | BAR-8 | `custom/voxtype` | **No era una pérdida**: el indicador `Dictation` ya viene dentro de `omarchy.indicators`, que está en la barra. Más el OSD propio de voxtype (ver VOX-4). |
| ✅ | BAR-9 | `custom/dnd` + los 3 indicadores | `omarchy.indicators` agrupa los seis, y el plugin `shavanced.notification-center` añade historial y DND — más de lo que hacía el `custom/dnd` propio, que era un script sobre `makoctl`. |
| ✅ | BAR-10 | `clock` con calendario anual y locale `en_GB` | `omarchy.clock` configurado con formato propio. El calendario anual no se reprodujo y no se ha echado de menos. |
| ✅ | BAR-11 | Integración con el tema | Nativa; los plugins de terceros también se declaran theme-aware. |
| ✅ | BAR-12 | `hyprland/.config/waybar/` (3 ficheros) | **Borrado el 2026-08-24.** waybar desinstalada por el propio upgrade; mata también la trampa del restow que recreaba `~/.config/waybar`. |

**Bloque cerrado el 2026-08-30.** La barra nueva se adopta tal cual y no se
migra nada de waybar. La única entrada viva es BAR-3, aparcada. Lo que queda
por hacer no es de la barra sino de stow: `shell.json` y `plugins/` no están
versionados.

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
| ✅🔍 | VOX-3 | `pause_media = true` | **Bug de Omarchy 4, no nuestro. Arreglado con un puente, no con una decisión.** El daemon avisaba en cada grabación (`WARN playerctl not found or failed to run`) y no pausaba Spotify. Corrige lo que decía este documento el 2026-08-23: voxtype **no** habla MPRIS directamente, llama a `playerctl` por fuera (`src/audio/media.rs`, *"Requires playerctl to be installed"*). `pause_media = true` lo pone **Omarchy en su propio default** (`default/voxtype/config.toml:29`) y fue `omarchy-upgrade-to-quattro` el que desinstaló `playerctl` el 2026-08-22 18:59, en el mismo lote que waybar, mako, swayosd e hypridle. **Ya está reportado upstream**: issue [#7135](https://github.com/basecamp/omarchy/issues/7135) (abierta 2026-08-16, confirmada por 3 personas, también en instalación limpia) y PR [#7192](https://github.com/basecamp/omarchy/pull/7192) sin mergear; un mantenedor dice que **voxtype 1.0.0 lo arregla upstream** (hoy el paquete va por 0.7.5). **Hecho el 2026-08-24**: `pacman -S playerctl` a mano, verificado que vuelve a pausar. |
| ✅ | VOX-5 | Retirar `playerctl` | **Desinstalado (2026-09-21).** Cerrada la condición de salida que se escribió en VOX-3. voxtype 1.0.1 **habla MPRIS nativo** por el bus de sesión (`org.mpris.MediaPlayer2.Player`, *"Uses MPRIS over the session D-Bus"*), así que el puente sobra. Cuidado si se vuelve a mirar: la config de ejemplo del binario **todavía dice** *"playerctl binary required"* — es un comentario obsoleto, no la implementación. `pause_media = true` se queda: "pause está bien" (1.0.1 añade `duck_media`, que baja el volumen en vez de pausar; no se adopta). |
| ⏭️ | VOX-4 | Indicador en la barra | **Sin objeto (2026-09-21).** El `custom/voxtype` de waybar murió con waybar, y quattro trae indicador de dictado **de serie**: `Dictation` está en `defaultIndicatorEntries` de `shell/plugins/bar/widgets/Indicators.qml`, y su `Dictation.qml` pinta 󰍬 grabando y 󰔟 transcribiendo leyendo el mismo `voxtype status` (`idle`/`recording`/`transcribing`). Encima voxtype trae su propio OSD. Nada que migrar ni que escribir. **Queda en pie el aviso**: `omarchy-voxtype-status` informa `Backend: CPU (AVX2)` leyendo los campos del modo local sin enterarse de que el modo es remoto — **miente sobre dónde se transcribe**. |
| ✅🔍 | VOX-6 | Driver de tecleado: `dotool` en vez de `wtype` | **Los acentos desaparecían al dictar en Slack y en la terminal salían bien.** No era el post-process (VOX-2): verificadas las 20 transcripciones con saltos de línea de 10 días de log, las 20 limpias. Es el tecleado: `wtype` sube un keymap sintético por el protocolo virtual-keyboard y **Electron no lo respeta** con layouts de teclas muertas — el nuestro es `us`/`altgr-intl` — bug abierto y **cerrado como "not planned"**: [electron#46823](https://github.com/electron/electron/issues/46823). Descartado `mode = "paste"` tras probarlo: con `paste_keys = "super+v"` (el *Universal paste* de Omarchy, `default/hypr/bindings/clipboard.lua:46`) el SUPER inyectado se mezclaba con el del PTT y **abría el menú de apagado** — es justo lo que avisa el comentario de ese fichero; y con `shift+insert`, que sí funcionaba, no inserta nada mientras mantengas SUPER apretado. La solución es `driver_order = ["dotool", "wtype", "clipboard"]`: dotool escribe keycodes evdev reales por `/dev/uinput` y Electron lo trata como teclado físico. **Coste en máquinas nuevas**: `pacman -S dotool`, `usermod -aG input $USER` y **volver a iniciar sesión** (el servicio de usuario hereda los grupos de la sesión); `input` da lectura de todos los dispositivos de entrada. `wtype` se queda de segundo para que sin eso el dictado siga escribiendo. |
| 🔍 | VOX-7 | `dotool_xkb_layout` no sigue al layout activo | dotool no lee el layout del compositor, se le pasa a mano (`us` / `altgr-intl`, copiado de `input.conf`). `kb_layout = us,es`: **si alguna vez dictas con el `es` seleccionado, los acentos volverán a salir mal**. Sin resolver porque hoy no se usa el `es` para dictar. |
| 🔍 | VOX-8 | Dos fallos latentes en `voxtype-clean-transcript` | **No se arreglan: hoy no se manifiestan y el usuario prefiere no tocar lo que funciona (2026-08-28).** Apuntados para no volver a diagnosticarlos desde cero. (a) `perl -CSDA` decodifica en modo estricto: si el texto llega con un multibyte partido (solo posible con acentuados) el script muere con `exit 255`, voxtype cae al fallback y escribe la transcripción cruda **con todos los saltos** — sin dejar rastro en el log. (b) la línea `s/(?<=[\p{L}\p{N}])\n(?=[\p{L}\p{N}])//g` borra el salto **sin meter espacio**, así que pega palabras (`prueba\ncon` → `pruebacon`) cuando un segmento no acaba en puntuación; hoy no salta porque whisper.cpp siempre manda el espacio inicial de segmento, que es costumbre del servidor y no garantía. Verificado el 2026-08-27 sobre las 20 transcripciones con saltos de 10 días de log: 0 fallos. Arreglo si algún día hace falta: `Encode::FB_DEFAULT` en vez de `-CSDA`, y limitar el join-sin-espacio a escrituras sin espacios (han/kana/hangul/thai). |

**✅ VOX-1 decidido el 2026-08-28: se quedan los tres.** `SUPER+SPACE` es el que
se usa en la práctica; `F9` y `SUPER+CTRL+X` (toggle) no molestan y se conservan.
Se cierra la prueba que vencía el 2026-08-30 sin retirar ninguno.

## Bloque 6 — Captura de pantalla

| St. | ID | Entrada | En quattro |
|---|---|---|---|
| ⏭️ | CAP-1 | Submap `capture` (`SUPER+SHIFT+C`): editar, clipboard, grabar, color picker, share | **Descartado con el resto de submaps (2026-08-28).**  Cubierto casi al completo: `SUPER+CTRL+C` (menú de captura), `PRINT`, `ALT+PRINT` (grabar), `SUPER+PRINT` (picker), `SUPER+CTRL+S` (share). Además `SUPER+SHIFT+C` era Calendar de HEY, ahora libre (BND-18). |
| ⏭️ | CAP-2 | `SUPER+SHIFT+F` screenshot `smart copy` | **Descartado (2026-09-21).** `PRINT` y el menú de `SUPER+CTRL+C` cubren la captura; en quattro el acorde es el gestor de archivos y no se le disputa (regla 10). |
| ✅ | CAP-3 | `hypr/scripts/screencast-dnd` | **Resucitado (2026-09-21)**: "esto me encantaba y lo echo de menos". Llevaba sin arrancar desde el 22 de agosto (su `exec-once` vivía en el `autostart.conf` muerto). Reescrito contra `omarchy-shell notifications`, que tiene IPC de lectura (`dndState`) y de escritura (`setDnd on|off`) — el `makoctl mode` + `dnd-toggle` de Omarchy 3 ya no existen. Se conserva lo que lo hacía bueno: el fichero de estado marca "lo encendí yo", así que un DND manual previo ni se toca ni se apaga al dejar de compartir. Añadido `rm -f` al arrancar, porque una sesión que muera compartiendo pantalla dejaba el fichero y el siguiente `Close` apagaba un DND ajeno. No hay equivalente de serie en quattro: `SUPER+CTRL+coma` silencia a mano, pero nada reacciona al portal. |
| ✅ | CAP-4 | — | Anotado y nada que hacer: `SUPER+CTRL+PRINT` hace OCR de un screenshot, y durante la selección hay control por teclado (`RETURN` ventana, `TAB` siguiente). Feature nueva, no tarea. |

## Bloque 7 — Which-key y submaps ⏭️ CERRADO

**El which-key está muerto y barrido (2026-08-28)**: WK-1 se descartó arrastrado
por BT-1, y WK-2 a WK-5 se cerraron el mismo día borrando los ficheros. Ya no hay
`hyprland/.config/eww/`, ni `docs/which-key.md`, ni `exec-once` en `autostart.conf`.
**Y los submaps se fueron detrás el mismo día**: "nos cargamos todos los subs,
ya nos hemos cargado eww igualmente". `submaps.conf` y `submaps/` enteros
borrados, más su `source =` en `hyprland.conf`. **Bloque cerrado.**

| St. | ID | Entrada | Nota |
|---|---|---|---|
| ⏭️ | WK-1 | ¿Se sigue queriendo which-key? | **Descartado el 2026-08-28**, arrastrado por BT-1: el submap de bluetooth era el que lo justificaba y se fue. `eww` desinstalado el mismo día (no tenía dependencias inversas y no estaba corriendo). Barrido completo el mismo día. |
| ✅ | WK-2 | `eww/which-key-daemon.sh` | **Borrado.** Escuchaba el evento `submap` por socket con `socat` y parseaba `hyprctl binds`. Archivo: `git show master:hyprland/.config/eww/which-key-daemon.sh`. |
| ⏭️ | WK-3 | Parseo de `hyprctl binds` | Sin objeto tras WK-1: se va con el daemon. Se deja la nota por si algún día se parsean bindings otra vez.  **Resuelto como hecho**: `-j` vuelve a dar JSON válido en 0.56.2 y 226/228 binds conservan `description`. El hack de `8acedd6` se puede tirar. |
| ⏭️ | WK-4 | Color del borde del popup | Sin objeto tras WK-1: no hay popup.  Salía de `~/.config/omarchy/current/theme/swayosd.css`. swayosd no existe y la ruta del tema cambió a `~/.local/state/omarchy/current`. Buscar equivalente. |
| ✅ | WK-5 | `eww/eww.yuck`, `eww/eww.scss` | **Borrados** con el resto de `hyprland/.config/eww/`, que ya no existe. |
| ⏭️ | SUB-1 | Submap `apps` (`SUPER+R`) | **Descartado.** Spotify, Browser, Slack, Telegram, WhatsApp, Nautilus, btop, Docker, YouTube, Gemini. Verificado contra los defaults: todo tiene ya su `SUPER+SHIFT+*` (o `SUPER+CTRL+T` para btop) **salvo Telegram y Gemini**, y Slack ni está instalado. **Lo que se pierde son esos dos atajos** — ambos siguen a un `SUPER+SPACE` y escribir el nombre, porque al teclear en el menú raíz se cargan todos los providers. `SUPER+R` queda libre. |
| ⏭️ | SUB-2 | Submap `resize` (`SUPER+SHIFT+R`) | **Descartado, cubierto de sobra.** Eran hjkl y flechas con paso fijo de 50px. Los defaults (`SUPER+SHIFT+EQUAL/MINUS`, con `ALT` y `CTRL` para las otras dos granularidades) hacen lo mismo sin entrar en modo. |
| ⏭️ | SUB-3 | Submap `notifications` (`SUPER+COMMA`) | **Descartado.** Además `makoctl` no existe, así que 5 de sus 6 acciones ya estaban muertas.  Cubierto al 100% de serie: `SUPER+comma` (última), `SUPER+SHIFT+comma` (todas), `SUPER+CTRL+comma` (silenciar), `SUPER+ALT+comma` (invocar), `SUPER+SHIFT+ALT+comma` (historial). Y `makoctl` no existe. Sin equivalente directo solo "dismiss group". |
| ⏭️ | SUB-4 | Mecánica de los submaps | **Sin objeto**: no sobrevivió ninguno, así que no hay nada que rehacer con `hl.define_submap`. |

## Bloque 8 — Webapps ✅ CERRADO

La migración regeneró los **3 lanzadores preinstalados de Omarchy** y se llevó
`env WEBAPP_CONTEXT=Personal` y los iconos propios. Los 10 webapps creados a
mano (ChatGPT, GitHub, Outlook, Gemini, Telegram, OneDrive…) están intactos.

**Cerrado el 2026-09-13 sin trabajo**: verificado que lo que se perdió no hacía
nada. Los 3 lanzadores siguen enlazados al repo (Omarchy escribió *a través* del
symlink, así que el repo tiene ya su versión) y funcionan a diario.

| St. | ID | Entrada | Nota |
|---|---|---|---|
| ✅ | WEB-1 | WhatsApp, YouTube, Google Photos `.desktop` | **Sin pérdida real.** Perdieron `env WEBAPP_CONTEXT=Personal`, pero `zen-open-url` hace `CONTAINER="${WEBAPP_CONTEXT:-Personal}"`: **Personal ya es el valor por defecto**, así que el contenedor de Zen sale igual. El `Comment=` que también se fue no lo leía nadie. |
| ✅ | WEB-2 | Iconos | **Se ven bien.** Los `.desktop` pasaron de un `Icon=` con ruta absoluta a `Icon=whatsapp` / `youtube` / `google-photos`, y quattro instala esos tres en `/usr/share/icons/hicolor/{48x48,256x256}/apps/`. Los otros 9 lanzadores siguen con su PNG propio enlazado desde `~/.local/share/applications/icons/`. Efecto colateral: `WhatsApp.png`, `YouTube.png` y `Google Photos.png` quedan versionados sin que nadie los use — se dejan, pesan nada. |
| ⏭️ | WEB-3 | Que Omarchy no los vuelva a pisar | **Sin objeto tras WEB-1/WEB-2.** Si lo que escribe Omarchy encima funciona igual, que lo pise deja de ser un problema. Quien lo pisó fue `omarchy-upgrade-to-quattro`, que es de un solo uso, no el update normal. |
| ✅ | WEB-4 | Integración open-in-zen | `WEBAPP_CONTEXT` + `bin/zen-open-url` + extensión en `webapps/.config/chromium-extensions/open-in-zen/` + `zen-open-handler.desktop`. **Sigue en pie y en uso.** Las 10 webapps propias conservan su `WEBAPP_CONTEXT=Work`/`Personal`, `zen-open-url` está intacto, y las 3 de Omarchy caen en Personal por el valor por defecto del script. Ver [webapps.md](webapps.md). |
| ⏸️ | WEB-5 | `install-webapps.sh` | **Aparcada.** No estorba y no se ejecuta salvo en máquina nueva. Compararlo con `omarchy-webapp-install` / `omarchy-webapp-remove` es trabajo de la misma familia que REP-7 (`install-hyprland.sh`), así que se mira cuando se miren los instaladores, no ahora. |

## Bloque 9 — Scripts propios

| St. | ID | Script | Estado |
|---|---|---|---|
| ✅ | SCR-1 | `hyprland/.local/bin/hyprkeys` | **Borrado (2026-09-21).** Irreparable: con config Lua `hyprctl binds` ya no expone el comando. Sustituto `SUPER+K`. |
| ✅ | SCR-2 | `bin/.local/bin/dnd-toggle` | **Borrado (2026-09-21).** Roto por triple (`makoctl`, `swayosd-client`, `pkill waybar`). Lo que lo usaba era `screencast-dnd`, que ahora llama al IPC de omarchy-shell directamente. |
| ✅ | SCR-3 | `hypr/scripts/screencast-dnd` | Ver CAP-3: reescrito y de vuelta en el autostart. |
| ✅ | SCR-4 | `hypr/scripts/keyboard-layout-osd` | **Borrado** con TEC-4. |
| ✅ | SCR-5 | `bin/.local/bin/zen-open-url` | Funciona; Bloque 8 cerrado sin tocarlo. Nada que hacer. |
| ✅ | SCR-6 | `analyze_code`, `llm_spend`, `voxtype-clean-transcript` | Sin relación con Omarchy. `voxtype-clean-transcript` se verificó vivo en VOX-2; los otros dos no dependen de nada que quattro tocase. |

## Bloque 10 — Bindings sueltos ✅ CERRADO

Omarchy 4 trae **228 bindings de serie** (Omarchy 3 traía una fracción). Antes
de migrar cualquiera, mirar si ya existe.

### 10a — Idénticos al default: solo confirmar y borrar

`SUPER+RETURN` terminal · `SUPER+ALT+RETURN` tmux · `SUPER+SHIFT+RETURN` y
`SUPER+SHIFT+B` browser · `SUPER+SHIFT+ALT+B` browser privado · `SUPER+SHIFT+M`
Spotify · `SUPER+SHIFT+ALT+M` cliamp · `SUPER+SHIFT+N` editor · `SUPER+SHIFT+D`
lazydocker · `SUPER+SHIFT+A` ChatGPT · `SUPER+SHIFT+ALT+A` Grok ·
`SUPER+SHIFT+Y` YouTube · `SUPER+SHIFT+ALT+G` WhatsApp ·
`SUPER+SHIFT+CTRL+G` Google Messages · `SUPER+SHIFT+X` X ·
`SUPER+SHIFT+ALT+X` X Post · más las líneas comentadas de Obsidian y Google
Photos, que ahora existen de serie.

(`SUPER+SHIFT+G` Signal y `SUPER+SHIFT+E` email salieron de esta lista: ver
BND-18.)

| St. | ID | Entrada |
|---|---|---|
| ✅ | BND-1 | **Confirmados y borrados (2026-09-13).** El aviso de `SUPER+ALT+RETURN` queda resuelto: el default también pasa el directorio actual (`omarchy-launch-terminal` hace `--dir="$(omarchy-cmd-terminal-cwd)"`). Única diferencia de conducta, aceptada: el propio abría **siempre sesión de tmux nueva** (`tmux new`) y el default **se engancha a una sesión llamada `Work`** o la crea (`tmux attach || tmux new -s Work`). |
| ✅ | BND-18 | **Apps preinstaladas que no se usan (2026-08-28).** `hl.unbind` de `SUPER+SHIFT+G` (Signal), `SUPER+SHIFT+C` (Calendar HEY), `SUPER+SHIFT+E` (Email HEY) y `SUPER+SHIFT+ALT+E` (New email HEY). Solo unbind, sin rebind: el acorde queda libre. Signal sigue instalado, solo pierde el atajo. Ojo: `SUPER+CTRL+ALT+D` sigue siendo Calendar, pero es el panel de la barra, no HEY. |

### 10b — Chocan con un default de quattro

| St. | ID | Tecla | Era | Ahora es |
|---|---|---|---|---|
| ✅ | BND-2 | `SUPER+SPACE` | Dictado voxtype | **Se recupera para el dictado**; el menú a `SUPER+ALT+SPACE`. Ver VOX-1. |
| ⏭️ | BND-3 | `SUPER+D` | Lanzador (walker) | **Todo por defecto (2026-09-13).** walker no existe. El menú es `SUPER+SPACE` (dictado, VOX-1) y `SUPER+ALT+SPACE`. `SUPER+D` queda suelto. |
| ⏭️ | BND-4 | `SUPER+W` / `SUPER+SHIFT+Q` | Pop window out / cerrar ventana | **Todo por defecto (2026-09-13).** Se adoptan los de serie: `SUPER+W` cierra, `SUPER+O` saca la ventana. |
| ⏭️ | BND-5 | `SUPER+I` / `SUPER+O` / `SUPER+P` | Spotify: anterior / play-pause / siguiente | `SUPER+O` pop-out, `SUPER+P` pseudo. **`playerctl` no está instalado**; quattro usa `omarchy-shell media next\|playPause\|previous` sobre las teclas `XF86Audio*`. Ojo: lo propio era específico de Spotify (`--player=spotify`), lo nuevo va al reproductor activo.  **Resuelto por otra vía**: el multimedia acabó en `AltGr+7/8/9` sobre `omarchy-shell media` (ver el comentario de `bindings.lua`), que vale para cualquier reproductor. Los `SUPER+I/O/P` propios se borran. |
| ⏭️ | BND-6 | `SUPER+SHIFT+I/O/P` | Multimedia genérico | **Todo por defecto (2026-09-13).** Igual que BND-5: lo cubre `AltGr+7/8/9`. Los acordes vuelven a Obsidian y Google Photos. |
| ⏭️ | BND-7 | `SUPER+X` | Foco a ventana urgente | **Todo por defecto (2026-09-13).** "No lo uso ya". Queda el **cortar universal** de Omarchy. |
| ⏭️ | BND-8 | `SUPER+SHIFT+code:61` | Menú de keybindings | **Todo por defecto (2026-09-13).** `SUPER+K`. El acorde vuelve a 1Password. |
| ⏭️ | BND-9 | `SUPER+CTRL+P` | Toggle pseudo | **Todo por defecto (2026-09-13).** Pseudo en `SUPER+P`; `SUPER+CTRL+P` vuelve a ser el panel de energía. |
| ⏭️ | BND-10 | `SUPER+SHIFT+W` | Typora | **Todo por defecto (2026-09-13).** `typora` no está instalado y no vuelve. El acorde queda con Omawrite, el de serie. |
| ⏭️ | BND-11 | `SUPER+SHIFT+T` | btop | **Todo por defecto (2026-09-13).** `SUPER+CTRL+T`. |
| ✅ | BND-12 | `unbind SUPER+CTRL+X` | Se desbindeaba por peligroso en Omarchy 3 | Ahora es el toggle de dictado y se quiere: el `unbind` viejo se fue y el default se deja en paz. |

### 10c — Propios sin equivalente

| St. | ID | Binding | Nota |
|---|---|---|---|
| ⏭️ | BND-13 | `SUPER+H/J/K/L` foco y `SUPER+SHIFT+H/J/K/L` mover ventana | **Descartado 2026-08-23**: "no me importa, no lo uso mucho". Se borran sin sustituto; quedan los defaults con flechas. |
| ✅ | BND-14 | `SUPER+N` workspace vacío | **Único binding propio que se conserva del bloque (2026-09-13).** "Lo único que me podría gustar es el `SUPER+N`". No hay equivalente: `SUPER+TAB`, `SUPER+SHIFT+TAB` y `SUPER+CTRL+TAB` navegan entre escritorios que ya existen, ninguno salta al primero libre. `SUPER+N` estaba suelto en quattro (`SUPER+SHIFT+N` es el editor), así que no desplaza ningún default. Rehecho en `bindings.lua` como `hl.dsp.focus({ workspace = "empty" })`. |
| ⏭️ | BND-15 | `SUPER+apostrophe` / `SUPER+SHIFT+apostrophe` | Último workspace / mover al último (costumbre de i3). **Todo por defecto (2026-09-13).** `SUPER+CTRL+TAB` cubre el ir al último. **Mover la ventana al último se pierde**, sin sustituto — se acepta. |
| ⏭️ | BND-16 | `SUPER+BACKSLASH` toggle split | **Todo por defecto (2026-09-13).** `SUPER+J`. |
| ⏭️ | BND-17 | `SUPER+Q` cambiar layout | **Todo por defecto (2026-09-13).** Con un solo layout no hay nada que alternar. Se va con el script del OSD (TEC-4). |

## Bloque 11 — Monitores, aspecto y autostart

Baja prioridad por decisión explícita ("los monitores dan igual"). La trampa que
tenía este bloque (MON-2, las rayas del LG) se resolvió sola: el monitor murió.

| St. | ID | Entrada | Nota |
|---|---|---|---|
| ✅ | MON-1 | `GDK_SCALE=1` + `monitor=,preferred,auto,1` | **Nada que hacer (2026-09-21)**: `monitors.lua` ya trae exactamente eso de plantilla. |
| ⏭️ | MON-2 | Override del LG UltraGear a `2560x1440@120` | **Descartada: el monitor se murió (2026-09-21).** El panel ya no arranca, así que el workaround de las rayas negras se va con él. Bloque borrado de `monitors.conf`; cuando llegue el sustituto se configura de cero, sin arrastrar el `desc:` del viejo. Archivo: `git show master:hyprland/.config/hypr/monitors.conf`. |
| ⏭️ | MON-3 | ARZOPA portátil en `auto-left` | **Descartada (2026-09-21)**: "no la estoy usando". Se borra con `monitors.conf`; si vuelve, `position = "auto-left"` es una línea. |
| ✅ | MON-4 | `decoration.rounding = 8` | **Default (2026-09-21).** Un mes con el `rounding` de quattro (0) sin echarlo de menos. `looknfeel.conf` borrado; `looknfeel.lua` se queda con la plantilla comentada. |
| ✅ | AUT-1 | `exec-once = hyprsunset` | **Se borra sin sustituto (2026-09-21)**: lo arranca Omarchy. `hyprsunset.conf` sí se queda, que es de donde `nightlight-toggle` lee la temperatura (REP-3). |
| ⬜ | SUN-1 | **El indicador de la barra aplica 4000 K, no la temperatura propia** | Quattro tiene el valor de la luz nocturna escrito a fuego en **dos sitios distintos**: `ON_TEMP=4000` en `/usr/share/omarchy/bin/omarchy-toggle-nightlight` (atajo y menú) y `readonly property int nightTemperature: 4000` en `/usr/share/omarchy/shell/plugins/services/nightlight/Service.qml` (clic en el indicador de la barra). Ninguno de los dos lee `hyprsunset.conf`, y ninguno es editable: los sobrescribe el paquete en cada update. El primero ya está resuelto (`nightlight-toggle` propio, ver el registro del 2026-09-07). El segundo pide `omarchy plugin clone omarchy.nightlight` y editar `nightTemperature` en el clon — pero el clon cae en `~/.config/omarchy/plugins/`, **así que esto está bloqueado por REP-12** (ese directorio no está stowed). Mientras tanto: el indicador *muestra* el estado bien (usa el umbral `< 6000 K`, no el valor exacto); lo único que hace mal es el clic. |
| ✅ | AUT-2 | `exec-once = eww daemon` + `which-key-daemon.sh` | **Fuera de `autostart.conf`** con WK-1. |
| ✅ | AUT-3 | `exec-once = screencast-dnd` | **Rehecho en `autostart.lua`** con CAP-3, por `o.launch_on_start` (uwsm-app) en vez de `exec-once` a pelo: es un demonio de sesión y así systemd lo recoge al cerrar sesión. La ruta se compone con `os.getenv` en vez de dejar un `$HOME` al shell de `exec`. |
| ✅ | INP-1 | Gestos de touchpad de 3 dedos | **Activado (2026-09-21).** "No sabía que existía esa posibilidad. Quiero la configuración por defecto." Y resulta que el default *es* esto: Omarchy **no activa ningún gesto de serie**, y quattro trae la línea comentada en su propia plantilla (`/usr/share/omarchy/config/hypr/input.lua:53`). Copiada tal cual a `input.lua`: `hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })`. Ojo al cambio de API: `gestures:workspace_swipe` ya no existe en Hyprland 0.56, por eso la sintaxis vieja (`gesture = 3, horizontal, workspace`) no habría valido aunque se hubiera descomentado. Única entrada de la migración que **añade** algo en vez de decidir sobre un cadáver. **Probado en vivo el mismo día: "funciona el gesto de los tres dedos, me gusta".** |

## Bloque 12 — Idle y lock ✅ CERRADO

| St. | ID | Entrada | Nota |
|---|---|---|---|
| ✅ | IDLE-1 | Screensaver a 150s | **Coincide con el default, nada que hacer.** `~/.config/omarchy/shell.json` y `/usr/share/omarchy/config/omarchy/shell.json` tienen los dos `"idle": { "screensaver": 150, "lock": 300 }`. |
| ✅ | IDLE-2 | Lock a 152s | **El default de 300 *es* lo que se quería.** El 152 nunca fue la intención: era la aritmética del hack, porque el listener del screensaver reseteaba el contador de hypridle y había que pedir "la mitad + 2s de margen" para bloquear a los 5 minutos reales. Quattro cuenta los dos temporizadores por separado, así que `lock: 300` da exactamente el comportamiento que el 152 perseguía. Se queda el default. |
| ✅ | IDLE-3 | `hypridle.conf` entero | **Nativo y verificado funcionando (2026-09-13).** Lo hace `omarchy-sleep-lock.service` (unidad de usuario, `Restart=always`), que está *active (running)*. Mecánica: `omarchy-system-sleep-monitor` levanta un `systemd-inhibit --what=sleep --mode=delay` y escucha `PrepareForSleep` por DBus; al recibirlo llama a `omarchy-system-sleep-lock`, que pide el bloqueo al shell y **espera a que la sesión esté *secure*** antes de soltar el inhibidor, con un presupuesto de tiempo derivado del `InhibitDelayMaxUSec` de logind. Si no lo consigue, manda una notificación crítica. Es más cuidadoso que el `inhibit_sleep = 3` propio, que era una espera a ciegas. **Prueba de que dispara**: el script sale tras atender *un* evento y systemd lo rearranca, así que el contador de reinicios cuenta suspensiones — iba por 7, con entradas en el journal hasta el 2026-09-12. El `WARN` de `dbus-monitor` sobre *eavesdropping* que sale en cada arranque es ruido conocido, no un fallo. |
| ✅ | IDLE-4 | `hyprlock.conf` | **Nada que rescatar.** El lock nuevo es un plugin de Quickshell (`shell/plugins/lock/`) que se pinta con el tema, así que el estilo propio (fondo con `blur_passes = 3`, JetBrainsMono, `rounding = 0`) ya no tiene dónde ir y se decide por defecto. La autenticación es PAM: `omarchy-apply-lock` escribe `/etc/pam.d/omarchy-lock-password`. **La huella no se pierde porque nunca se usó**: el fichero propio la traía con `fingerprint:enabled = false` y `fprintd` no está instalado. Quattro sí la soporta (escribiría `/etc/pam.d/omarchy-lock-fingerprint`) si algún día se quiere. Nota muerta aparte: el fichero hacía `source` de `~/.config/omarchy/current/theme/hyprlock.conf`, ruta que en quattro es `~/.local/state/omarchy/current`. |
| ✅ | IDLE-5 | `omarchy-toggle-idle` | **Verificado presente** en los atajos activos como `SUPER+CTRL+I` → *Toggle locking on idle*. No era una tarea, era una feature nueva que apuntar. |

## Bloque 13 — Limpieza del repo

| St. | ID | Fichero | Nota |
|---|---|---|---|
| ✅ | REP-1 | `hypr/hyprland.conf` | **Borrado (2026-09-21).** Su última línea viva era el `env = SSH_AUTH_SOCK`, ya cubierto por el paquete `ssh/` (`cb15c6f`). Con esto `hyprland/` es Lua puro más tres `.conf` que no son de Hyprland. |
| ✅ | REP-2 | `hypr/hypridle.conf`, `hypr/hyprlock.conf` | **Borrados (2026-09-21)** con IDLE-3 e IDLE-4 cerrados. Ninguno de los dos binarios está instalado. |
| ✅ | REP-3 | `hypr/hyprsunset.conf` | **Se queda.** Sigue siendo `.conf` en quattro y es la fuente de la temperatura para `nightlight-toggle` (ver SUN-1). |
| ✅ | REP-4 | `hypr/xdph.conf` | **Se queda, pero no era config propia**: es **byte a byte** el default de quattro (`/usr/share/omarchy/config/hypr/xdph.conf`). El portal lo lee de `~/.config/hypr/`, así que el fichero tiene que existir ahí. Decisión sin decisión. |
| ✅ | REP-5 | `hypr/.luarc.json` | **Se queda versionado.** Apunta a los stubs de `/usr/share/hypr/stubs`, que es lo que da autocompletado y tipos al editar los `.lua` — o sea sirve en cualquier máquina, no solo en esta. |
| ✅ | REP-6 | **`i3/` (45 ficheros)** | **Borrado (2026-08-28)**. No solo i3+i3blocks: el directorio guardaba también `.config/polybar/` (6 ficheros) y `.config/rofi/` + `.local/share/rofi/themes/` (8), igual de muertos — **rofi tampoco está instalado** y quattro lanza `omarchy-launch-walker`. Verificado antes de borrar: nada stowed (`~/.config/{i3,rofi,polybar}` no existían), ningún paquete instalado, todo X11 (`xss-lock`, `xinput`, `setxkbmap`, `feh`, `xset dpms`, `dex --environment i3`), y las `APIKEY` de `openweather` eran placeholders literales. Recuperable en `git show 22e4155:i3/…`. Arrastró: sección "i3blocks Scripts" y comandos de *Testing* de `AGENTS.md`, y en `install-hyprland.sh` el paquete `rofi-wayland` más 5 líneas de comentarios de un agente preguntándose dónde vivía la config de rofi. Y se llevó por delante el `pkill -RTMIN+10 i3blocks` muerto de `bin/.local/bin/bt`, que BT-2 había dejado a propósito. |
| ⏭️ | REP-7 | `install-hyprland.sh` | **Borrado (2026-09-21)**, no reescrito. Instalaba `hypridle`, `hyprlock`, `waybar`, `mako`, `swayosd-git` y clonaba omarchy a mano: obsoleto de arriba abajo. **Deuda aceptada a sabiendas**: los tres pasos manuales de una máquina nueva (`pacman -S dotool`, `usermod -aG input $USER`, re-login) se quedan sin sitio ejecutable; están escritos en VOX-6 y nada más. |
| ✅ | REP-8 | `docs/hyprland.md` | **Reescrito entero (2026-09-21).** Describía Omarchy 3: waybar, mako, submaps, `hyprkeys`, `~/.local/share/omarchy/` y el `source =` de `hyprland.conf`. La versión nueva cuenta las tres capas de quattro (con la ruta del tema ya en `~/.local/state/`), los seis módulos Lua y qué hay en cada uno, y por qué `hyprctl binds` ya no sirve. Se conservan las dos secciones que seguían siendo ciertas y caras de reconstruir: voxtype/dotool y el DND al compartir pantalla, esta última actualizada al IPC nuevo. |
| ✅ | REP-9 | `docs/which-key.md` | **Borrado** con WK-1, y fuera del índice de `AGENTS.md`. Archivo: `git show master:docs/which-key.md`. |
| ✅ | REP-10 | `docs/webapps.md` | **Verificado y corregido con una nota (2026-09-21).** El documento era correcto salvo en un punto: enseñaba a poner `env WEBAPP_CONTEXT=Personal` en los `.desktop` como si hiciera falta. Tras WEB-1 se sabe que no — `zen-open-url` usa `Personal` por defecto — y que Omarchy pisa sus tres lanzadores en un upgrade mayor. Añadido eso; el resto se queda. |
| ⏸️ | REP-12 | **`~/.config/omarchy/` no está stowed** | **Aparcada por decisión explícita (2026-08-28)**: "no quiero versionar de momento la configuración de omarchy porque todavía no entiendo cómo funciona esta versión exactamente". Se retoma cuando la barra nueva se entienda. Hallazgo del 2026-08-28 barriendo WK-1: `~/.config/omarchy/hooks/theme-set` era un fichero real, **nunca versionado**, con un `eww reload` dentro — 8 meses de deriva silenciosa, el mismo patrón que VOX-2. Y el directorio entero es real, no un symlink al repo, así que **`shell.json` (toda la config de la barra, Bloque 4) tampoco está versionado**. Choca de frente con la decisión "todo lo configurable va stowed" del 2026-08-23. Decidir qué de `~/.config/omarchy/` entra al repo. |
| ✅ | REP-11 | `CLAUDE.md` | **Actualizado (2026-09-21).** La regla "NEVER modify `~/.local/share/omarchy/`" pasa a `/usr/share/omarchy/`, diciendo que es un paquete pacman y que la ruta vieja es solo un symlink de compatibilidad. Añadida una regla nueva que faltaba y que es la que más despista a un agente: **Hyprland se configura en Lua**, con el entrypoint señalado. |

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
| 2026-08-28 | BT-2 | Rectificada: se quita el `pkill … i3blocks` de `bt` | Se conservaba solo por "no tocar el script"; con `i3blocks` fuera del repo, dejar una llamada a un binario que no existe es ruido, no prudencia |
| 2026-08-28 | REP-6 | El borrado se lleva también rofi y polybar | Vivían dentro de `i3/` pero no son de i3; la verificación mostró que están igual de muertos (sin instalar, sin stowear), así que separarlos habría sido ceremonia sin decisión detrás |
| 2026-08-23 | — | Regla 10: atajos lo más estándar posible | Cada binding propio hay que revisarlo en cada upgrade y puede chocar con un default nuevo; esta migración es la factura de no haberlo hecho así. No aplica al teclado (TEC-1), que no es un atajo de Omarchy |
| 2026-08-24 | — | Regla 11: buscar en los issues de Omarchy antes de decidir | En VOX-3 el bug estaba reportado (#7135), confirmado por 3 personas y con PR y arreglo upstream en camino. Saberlo convirtió la decisión en "puente temporal" en vez de "arreglo propio", que es más barato y más honesto |
| 2026-08-24 | VOX-3 | Instalar `playerctl` a mano como puente, no como decisión | El bug es de Omarchy (envía `pause_media` activado y desinstala la herramienta). Ya hay issue #7135 y PR #7192, y voxtype 1.0.0 lo arregla upstream: instalarlo recupera la función hoy sin comprometerse a mantenerlo |
| 2026-08-28 | BT-1 | Submap de bluetooth descartado; se cierra el Bloque 2 entero | El panel de serie (`SUPER+CTRL+B`) basta. Los atajos por MAC llevaban 6 días muertos sin echarse de menos: "me funciona bastante bien por defecto tal como está". `SUPER+B` estaba libre y era migrable, así que no se descarta por coste sino porque el default gana (regla 10) |
| 2026-08-28 | BT-2, BT-3 | `bt` y `bt-toggle` se quedan | Son comandos de un disparo, no demonios: no cuestan nada por estar. Y `bt-toggle` no tiene sustituto — ningún `omarchy-audio-*` cambia el perfil A2DP↔HFP de la tarjeta, así que borrarlo perdería el micro del auricular |
| 2026-08-28 | SUB-1..4, CAP-1 | Todos los submaps descartados | "Nos cargamos todos los subs, ya nos hemos cargado eww igualmente". Sin popup el modo pierde su affordance, y los defaults cubren casi todo. Única pérdida real: los atajos de Telegram y Gemini, a un `SUPER+SPACE` de distancia |
| 2026-08-28 | REP-12 | Versionar `~/.config/omarchy/` se aparca, no se descarta | "Todavía no entiendo cómo funciona esta versión exactamente". Versionar antes de entender qué es config y qué es estado regenerado sería meter ruido en el repo |
| 2026-08-28 | REP-12 | Abierta entrada nueva: `~/.config/omarchy/` no está stowed | El hook `theme-set` (con un `eww reload`) llevaba 8 meses fuera del repo sin que nadie lo notase. Si el hook derivó, `shell.json` puede derivar igual — y ahí vive toda la barra |
| 2026-08-28 | WK-2, WK-5, AUT-2, REP-9 | Barrido del which-key en el mismo día que WK-1 | Regla 8: los ficheros muertos se van en el commit de su entrada. `hyprland/.config/eww/` entero, `docs/which-key.md`, las dos `exec-once` de `autostart.conf` y la línea del índice de `AGENTS.md` |
| 2026-08-28 | WK-1 | Which-key descartado y `eww` desinstalado | Consecuencia directa de BT-1: el submap de bluetooth era lo que lo sostenía. Sin submaps propios, el daemon eww + socat + hoja de estilo no tiene a quién servir |
| 2026-08-29 | WS-3 | Ferdium se cae, Slack se queda | Ferdium no está instalado ni vuelve. Slack sí lo estaba: el paquete es `slack-desktop` y la comprobación buscaba `slack` a secas — hecho corregido antes de decidir, no después |
| 2026-08-29 | WS-* | Las reglas viven en `windowrules.lua` propio, no al final de `hyprland.lua` | Omarchy sugiere colgarlas del entrypoint, pero eso mezcla "qué se carga" con "qué contiene". Un módulo más junto a los otros cinco cuesta una línea y mantiene el patrón |
| 2026-08-28 | VOX-1 | Se conservan los tres atajos de dictado | `SUPER+SPACE` es el que se usa; `F9` y `SUPER+CTRL+X` no estorban. Cierra la prueba que vencía el 2026-08-30 |
| 2026-08-28 | VOX-6 | Tecleado por `dotool`, descartado `mode = "paste"` | Electron ignora el keymap sintético de `wtype` y se come los acentuados en Slack ([electron#46823](https://github.com/electron/electron/issues/46823), *not planned*). El paste inyectaba pulsaciones que chocaban con el SUPER del PTT; `dotool` manda keycodes evdev reales y Electron lo trata como teclado físico |
| 2026-08-28 | VOX-8 | No arreglar los fallos latentes del limpiador | "Yo ya no lo veo al menos con esta configuración". No se manifiestan hoy; quedan documentados en vez de tocar un script que funciona |
| 2026-08-28 | — | `max_duration_secs = 60` se queda | "Un minuto, tampoco me hace falta mucho más" |
| 2026-08-24 | BAR-* | Bloque 4 a prioridad baja | "En la nueva barra ya existe la mayoría de estas cosas, así que mejor todavía". El resumen de lo que había queda escrito y visible; se revisita cuando toque, sin prisa |
| 2026-08-23 | VOX-2 | Todo lo configurable va stowed y enlazado al repo, sin excepciones | Se usa en varias máquinas: lo que no está enlazado se queda en un solo ordenador y deriva en silencio. Esta entrada llevaba 4 meses derivada sin que nadie lo notase |
| 2026-08-23 | VOX-1 | Dictado push-to-talk en `SUPER+SPACE`; menú de Omarchy a `SUPER+ALT+SPACE`; `SUPER+CTRL+X` intacto como toggle | Excepción a la regla 10 porque el estándar no cubre el caso: `F9` exige FnLock y dos manos, y `SUPER+CTRL+X` es un toggle de tres teclas. La acción más usada se lleva el chord más cómodo, y el menú solo pierde el atajo a las apps, que ya se buscan desde la raíz |
| 2026-09-07 | SUN-1 | Luz nocturna a 3000 K, y `nightlight-toggle` propio que lee la temperatura de `hyprsunset.conf` | "Me gusta mi luz de noche pero la veo demasiado poco naranja". Los 4000 K de Omarchy son un filtro suave; 3000 K corta bastante más azul. El script propio existe porque el valor de Omarchy no es configurable, y **lee el `.conf` en vez de repetir la constante** para que manual y automático no puedan divergir: un solo sitio que tocar. Queda fuera el clic del indicador de la barra (SUN-1) |
| 2026-08-30 | BAR-* | La barra nueva se adopta tal cual; no se migra nada de waybar | "La barra nueva me gusta mucho, no creo que tengamos que migrar nada". 6 días de uso sin echar nada de menos valen más que una comparación módulo a módulo |
| 2026-09-13 | IDLE-* | Bloque 12 cerrado sin tocar la configuración | "Si el apagado de pantalla y bloqueo van bien por defecto, no tocaría nada". Comprobado y así es: los dos temporizadores coinciden con el default, y el 300 del bloqueo resulta ser justo lo que el hack del 152 perseguía. No es que se renuncie a lo propio, es que el default ya lo hace |
| 2026-09-13 | IDLE-3 | El bloqueo al suspender se da por bueno con evidencia, no por fe | `omarchy-sleep-lock.service` está corriendo y su contador de reinicios cuenta suspensiones atendidas (iba por 7). La entrada pedía "verificar suspender/despertar antes de borrarlo" y esto lo verifica desde el journal, sin tener que provocar una suspensión en la sesión del usuario |
| 2026-09-13 | WEB-* | Bloque 8 cerrado sin tocar nada | Lo único que se perdió fue `WEBAPP_CONTEXT=Personal` en tres lanzadores, y `zen-open-url` ya usa Personal como valor por defecto. Los iconos los pone quattro en el tema del sistema. "Ya tenemos eso corriendo, al menos a mí me funciona" — comprobado antes de darlo por bueno, no después |
| 2026-09-13 | BND-* | Todos los bindings propios del Bloque 10 se van, salvo `SUPER+N` | "Dejamos todo por defecto, lo demás no lo uso ya". Es la regla 10 aplicada de golpe: 14 entradas revisadas, 13 cubiertas por un default. El multimedia (BND-5, BND-6) ya se había resuelto por otra vía con `AltGr+7/8/9` |
| 2026-09-13 | BND-14 | `SUPER+N` se conserva como excepción a la regla 10 | Es el único sin equivalente: los tres atajos de escritorio de quattro navegan entre escritorios existentes, ninguno salta al primero libre. Y el acorde estaba suelto, así que no desplaza ningún default: la excepción no cuesta deuda |
| 2026-09-21 | TEC-3, TEC-7, MON-4 | Tres ajustes propios se van al default | Los tres vivían en `.conf` muertos desde el 22 de agosto, o sea que llevaban un mes sin aplicarse y nadie los echó de menos. La prueba de campo la hizo el accidente; confirmarla es más honesto que restaurarlos |
| 2026-09-21 | TEC-5, TEC-6 | Layout en la barra y `vconsole` aparcados | "Esto del altgr no me acaba de convencer, creo que vamos a volver a lo que teníamos antes". Las dos entradas son consecuencias de TEC-1; decidirlas antes de reabrir TEC-1 sería trabajo tirado |
| 2026-09-21 | CAP-3 | `screencast-dnd` se resucita, no se borra | "Esto me encantaba y lo echo de menos" — la única entrada del barrido que se salva. Quattro no lo hace de serie, y el IPC nuevo (`dndState`/`setDnd`) permite conservar lo que lo hacía bueno: respetar el DND manual |
| 2026-09-21 | REP-7 | `install-hyprland.sh` se borra en vez de reescribirse | El agente recomendó reescribirlo pequeño para alojar los pasos manuales de dotool; el usuario decidió borrarlo. Se acepta la deuda por escrito: una máquina nueva dictará con los acentos rotos hasta que alguien lea VOX-6 |
| 2026-09-21 | MON-3 | ARZOPA descartada | "No la estoy usando". Con el LG muerto y la ARZOPA fuera, `monitors.conf` se queda sin contenido propio y se borra entero |
| 2026-09-21 | INP-1 | Se activan los gestos de 3 dedos | No es un ajuste propio: Omarchy no trae gestos de serie y la línea está comentada en su plantilla, así que activarla *es* el default. La regla 10 no se resiente |
| 2026-09-21 | VOX-5 | `playerctl` desinstalado | voxtype 1.0.1 habla MPRIS nativo; el puente de VOX-3 cumplió su condición de salida. El comentario "playerctl binary required" de su config de ejemplo está obsoleto y por poco nos engaña |
| 2026-09-21 | VOX-6 | El arreglo de dotool queda pendiente, sin urgencia | El grupo `input` no está aplicado y el dictado cae a `wtype`: funciona en todo menos en los acentos dentro de Electron. "Eso funciona increíble ya" — se deja porque el síntoma real es estrecho y el arreglo pide cerrar sesión |
| 2026-09-21 | REP-8, REP-10, REP-11 | Los tres documentos se cierran a la vez | Son la cara visible de todo lo decidido hoy: dejarlos describiendo waybar y `.conf` haría que el siguiente agente (o yo dentro de seis meses) trabajase contra un mapa falso. `hyprland.md` se reescribe entero, los otros dos son retoques |
| 2026-09-21 | MON-2 | El override del LG se borra en vez de portarse a Lua | El monitor murió. Portar una línea `desc:` de un panel que ya no existe es arrastrar deuda por definición; el sustituto se configurará de cero |
| 2026-09-13 | BND-15 | Aceptada la pérdida de "mover ventana al último escritorio" | No hay default equivalente y mantenerlo era el único motivo para conservar un binding en `SUPER+apostrophe`. Se pierde a sabiendas, no por descuido |
| 2026-08-30 | BAR-3 | cpu/memoria/temperatura/disco aparcada ⏸️, no descartada | Es la única pérdida real y pide código nuevo; aparcarla con el motivo escrito evita que se quede en ⬜ eterna |
