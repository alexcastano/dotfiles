-- Overrides propios de input. Todo lo que no esté aquí lo pone Omarchy en
-- /usr/share/omarchy/default/hypr/input.lua (repeat_rate 40, numlock,
-- touchpad.scroll_factor 0.4, scroll_touchpad de terminales... ya coinciden
-- con lo que tenía, así que no hace falta repetirlo).

-- Teclado: `us` con variante `altgr-intl`. El español se escribe con AltGr sin
-- cambiar nunca de layout:
--
--   AltGr+n = ñ      AltGr+/ = ¿      AltGr+Shift+1 = ¡
--   AltGr+a e i o u = á é í ó ú
--
-- La variante mueve los dead keys a AltGr, así que ' " ` ~ se escriben normal
-- (importante para código). Caps Lock = Ctrl. Ctrl derecho = Compose.
-- Coste: AltGr (Alt derecho) deja de ser Alt; el Alt izquierdo sigue igual.
--
-- shift:both_capslock_cancel es de Omarchy y se conserva a propósito: como Caps
-- Lock pasa a ser Ctrl, sin esto no quedaría ninguna forma de activar el Caps
-- Lock de verdad (los dos Shift juntos lo activan, uno solo lo cancela).
--
-- Alternativas descartadas y por qué: docs/omarchy-quattro-migration.md,
-- sección "Investigación cerrada: el teclado".
hl.config({
  input = {
    kb_layout = "us",
    kb_variant = "altgr-intl",
    kb_options = "ctrl:nocaps,compose:rctrl,shift:both_capslock_cancel",
  },
})
