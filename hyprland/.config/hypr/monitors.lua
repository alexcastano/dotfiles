-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and supported resolutions with: hyprctl monitors all

-- Ojo: el catch-all no usa la forma de la plantilla (`local omarchy_monitor_scale`
-- ni `output = "", mode = ..., scale = N` en ese orden) a propósito. Así
-- omarchy-hyprland-monitor-scaling (SUPER+/) no lo reescribe: si escribe aquí,
-- Hyprland se autorecarga, la regla del AOC vuelve a 1.25 y el cambio no dura
-- ni un segundo (y de paso la escala acaba también en el portátil). Sin
-- escribir, SUPER+/ cambia la escala en vivo hasta el próximo reload o
-- reconexión, y al conectar cada monitor arranca con su escala de aquí.
--
-- Y el `tonumber("1")` en vez de `1`, también a propósito: con el portátil
-- acoplado, omarchy-hyprland-monitor-watch pasa cada 2 s
-- omarchy-hyprland-monitor-clamshell, que lee de aquí la escala del panel y
-- si la viva no coincide la devuelve a la fuerza (deshaciendo SUPER+/ en el
-- portátil, y de paso el reaplique de reglas devuelve el AOC a 1.25). Si el
-- valor no es un número literal, el script lo da por "lo decide Hyprland" y
-- no corrige nada. Para Lua es exactamente 1.
hl.env("GDK_SCALE", "2")
hl.monitor({ output = "", scale = tonumber("1"), mode = "preferred", position = "auto" })
hl.monitor({ output = "DP-3", mode = "preferred", position = "auto", scale = 1.6 })
hl.monitor({ output = "DP-1", mode = "preferred", position = "auto", scale = 1 })

-- AOC 32" 4K: un poco más grande que el resto. Por descripción, no por
-- conector, para que valga sea cual sea el puerto (DP-1, DP-2...).
hl.monitor({ output = "desc:AOC U32U3CV AUJS19A000121", mode = "preferred", position = "auto", scale = 1.25 })

-- Configure a specific monitor.
-- hl.monitor({ output = "DP-2", mode = "2560x1440@144", position = "0x0", scale = 1 })

-- Portrait/rotated secondary monitor (transform: 1 = 90°, 3 = 270°).
-- hl.monitor({ output = "DP-2", mode = "preferred", position = "auto", scale = 1, transform = 1 })
