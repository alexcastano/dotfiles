-- Overrides propios de input. Todo lo que no esté aquí lo pone Omarchy en
-- /usr/share/omarchy/default/hypr/input.lua (repeat_rate 40, numlock,
-- touchpad.scroll_factor 0.4, scroll_touchpad de terminales... ya coinciden
-- con lo que tenía, así que no hace falta repetirlo).

-- Teclado: `us` con variante `altgr-intl` (de vuelta tras TEC-8, 2026-10-01:
-- las teclas muertas de `intl` resultaron insufribles). `' " ` ~` son literales
-- y el español se escribe con AltGr, sin cambiar de layout:
--
--   AltGr+a = á     AltGr+n = ñ     AltGr+/ = ¿     AltGr+Shift+1 = ¡
--
-- Segundo layout `es` (2026-11-06), para escribir español como antes de
-- quattro. SUPER+I alterna (es el atajo de Omarchy: omarchy-input-method cycle
-- recorre los layouts de Hyprland). `us` tiene que ir primero: dotool crea un
-- teclado virtual nuevo cada vez que escribe y Hyprland le da el primer layout,
-- que es el que voxtype/config.toml le dice a dotool. Por eso el dictado
-- funciona aunque tengas `es` activo.
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
    kb_layout = "us,es",
    kb_variant = "altgr-intl,",
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
