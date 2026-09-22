-- Overrides propios de input. Todo lo que no esté aquí lo pone Omarchy en
-- /usr/share/omarchy/default/hypr/input.lua (repeat_rate 40, numlock,
-- touchpad.scroll_factor 0.4, scroll_touchpad de terminales... ya coinciden
-- con lo que tenía, así que no hace falta repetirlo).

-- Teclado: `us` con variante `intl` — **en prueba (TEC-8, 2026-09-21)**: se
-- vuelve a las teclas muertas a ver si el acento cae donde toca. El español se
-- escribe sin cambiar de layout, y ahora de dos maneras:
--
--   `'` + a = á     (tecla muerta: pulsar y soltar, sin mantener nada)
--   AltGr+a = á     (sigue estando, como antes)
--   AltGr+n = ñ     AltGr+/ = ¿     AltGr+Shift+1 = ¡
--
-- Coste de `intl` frente a `altgr-intl`: `' " ` ~` pasan a ser teclas muertas.
-- Para el literal, AltGr+la tecla, o la tecla + espacio. Es lo que duele al
-- escribir código, y es justo lo que hay que ver en esta prueba.
--
-- Caps Lock = Ctrl. Ctrl derecho = Compose. AltGr (Alt derecho) sigue siendo
-- ISO_Level3_Shift, así que los AltGr+7/8/9 de multimedia (MOD5+code:16/17/18
-- en bindings.lua) no se tocan. El Alt izquierdo sigue intacto.
--
-- shift:both_capslock_cancel es de Omarchy y se conserva a propósito: como Caps
-- Lock pasa a ser Ctrl, sin esto no quedaría ninguna forma de activar el Caps
-- Lock de verdad (los dos Shift juntos lo activan, uno solo lo cancela).
--
-- Alternativas descartadas y por qué: docs/omarchy-quattro-migration.md,
-- sección "Investigación cerrada: el teclado" y la entrada TEC-8.
hl.config({
  input = {
    kb_layout = "us",
    kb_variant = "intl",
    kb_options = "ctrl:nocaps,compose:rctrl,shift:both_capslock_cancel",
  },
})

-- Cambiar de escritorio deslizando tres dedos por el touchpad.
--
-- Es la línea que quattro trae comentada en su propia plantilla
-- (/usr/share/omarchy/config/hypr/input.lua), sin tocar: Omarchy no activa
-- ningún gesto de serie, así que esto es el default de Hyprland descomentado,
-- no un ajuste propio. En Omarchy 3 el equivalente era `gesture = 3,
-- horizontal, workspace`, que estaba escrito pero nunca activado.
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
