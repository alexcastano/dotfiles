-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- To disable every Omarchy default binding, set this in
-- ~/.config/hypr/hyprland.lua before require("default.hypr.omarchy"), then add
-- only the bindings you want below:
--   omarchy_default_bindings = false

-- To disable all preinstalled app/webapp bindings, set:
--   omarchy_preinstalled_bindings = false

-- Add a new binding.
-- o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")

-- Change an existing binding by unbinding it first, then binding the key again.
-- This example changes SUPER+SPACE from the launcher to the Omarchy root menu.
-- hl.unbind("SUPER + SPACE")
-- o.bind("SUPER + SPACE", "Omarchy menu", "omarchy-menu toggle root")

-- Disable a default binding without replacing it.
-- hl.unbind("SUPER + SHIFT + B")

-- Logitech MX Keys examples:
-- o.bind("SUPER + SHIFT + S", nil, "omarchy-capture-screenshot")
-- o.bind("SUPER + H", nil, "voxtype record toggle")
-- o.bind("SUPER + PERIOD", nil, "omarchy-shell shell toggle omarchy.emojis")

-- Dictation gets the most comfortable chord on the keyboard, because it is the
-- most-used binding of the day and none of the stock keys fit: SUPER+CTRL+X is a
-- three-key toggle, and F9 needs FnLock plus both hands on this ThinkPad (and
-- shifts around on the external keyboard). Push-to-talk beats toggle for short
-- dictation, and SUPER+SPACE is the only chord the left hand holds without
-- moving, leaving the right hand on the mouse.
--
-- SUPER+CTRL+X is deliberately left alone: it stays as the toggle for long
-- dictation, where holding a key for a minute is the wrong gesture.
hl.unbind("SUPER + SPACE")
o.bind("SUPER + SPACE", "Start dictation (push-to-talk)", "voxtype record start")
o.bind("SUPER + SPACE", "Stop dictation (push-to-talk)", "voxtype record stop", { release = true })

-- The Omarchy menu takes over the apps-menu chord. Dropping the apps menu costs
-- nothing: typing in the root menu loads every provider (see
-- loadProvidersForSearch in the omarchy.menu plugin), apps included, so
-- searching for an app still works from here. Only browsing the full app list
-- without typing is gone.
hl.unbind("SUPER + ALT + SPACE")
o.bind("SUPER + ALT + SPACE", "Omarchy menu", "omarchy-menu toggle root")

-- Multimedia en el portátil: el X1 Carbon Gen 12 no tiene teclas de transporte
-- (solo volumen/mute/brillo en la fila F), así que hacen falta acordes. Los
-- teclados externos (Keychron, Logitech) sí las traen y ya funcionan con los
-- defaults de Omarchy en default/hypr/bindings/media.lua, esto es solo para
-- cuando trabajo sin ellos.
--
-- Por qué AltGr+7/8/9 y no otra cosa:
--   - Alt+7/8/9 descartado: es el atajo de pestañas de Firefox/Zen en Linux, y
--     un bind de Hyprland consume la tecla antes de que llegue a la app, así
--     que Zen se quedaría sin ese atajo para siempre y en silencio.
--   - SUPER+O descartado: en quattro es "Pop window out", que quiero conservar.
--   - AltGr gana porque las apps no pueden reclamarlo como modificador: solo
--     ven el carácter resultante. En la variante altgr-intl esas tres
--     posiciones son dead_horn / dead_ogonek / leftsinglequotemark, que no uso.
--     Coste aceptado: pierdo la comilla tipográfica ' de AltGr+9.
--
-- Van por keycode y no por keysym porque con AltGr pulsado el keysym ya es
-- dead_horn, no "7" (7=code:16, 8=code:17, 9=code:18). AltGr es MOD5.
--
-- Sin locked=true a propósito: los defaults de Omarchy lo llevan porque son
-- teclas dedicadas, pero sobre la fila numérica dispararía el reproductor
-- mientras escribo la contraseña en la pantalla de bloqueo.
o.bind("MOD5 + code:16", "Previous track", "omarchy-shell media previous")
o.bind("MOD5 + code:17", "Play/Pause", "omarchy-shell media playPause")
o.bind("MOD5 + code:18", "Next track", "omarchy-shell media next")

-- Modo reunión de voxtype: graba micro + audio del sistema (loopback de
-- PipeWire, con cancelación de eco) durante toda la llamada, lo trocea en
-- chunks de 30 s y va transcribiendo cada uno. Al parar queda un transcript
-- continuo con timestamps y hablantes en ~/.local/share/voxtype/meetings/,
-- que se saca con `voxtype meeting export latest --speakers --timestamps`.
--
-- F8 y no un acorde: es una tecla que se pulsa dos veces al día (al empezar y
-- al acabar la reunión), no cien como el dictado, así que no compite con
-- SUPER+SPACE por comodidad — compite por ser fácil de recordar y no pisar
-- nada. Toda la fila F está libre de binds en Omarchy salvo las XF86 del
-- portátil, y F8 no es ninguna de ellas.
--
-- Sin locked=true a propósito, igual que las de multimedia: no quiero poder
-- abrir un micrófono desde la pantalla de bloqueo.
o.bind("F8", "Toggle meeting recording", "voxtype-meeting-toggle")

-- Apps preinstaladas de Omarchy que no uso: liberar el acorde en vez de
-- arrastrar el bind. Signal está instalado pero no lo abro nunca (y si lo
-- necesito, está en el lanzador), y HEY (calendario, correo y correo nuevo) es
-- el stack de Basecamp que Omarchy trae por defecto pero que no es el mío.
--
-- Solo unbind, sin rebind: prefiero el acorde libre y visible en
-- `omarchy menu keybindings` a un bind que no quiero. SUPER+SHIFT+G queda
-- suelto (WhatsApp sigue en SUPER+SHIFT+ALT+G, sin cambios).
hl.unbind("SUPER + SHIFT + G") -- era: Signal
hl.unbind("SUPER + SHIFT + C") -- era: Calendar (HEY)
hl.unbind("SUPER + SHIFT + E") -- era: Email (HEY)
hl.unbind("SUPER + SHIFT + ALT + E") -- era: New email (HEY)
