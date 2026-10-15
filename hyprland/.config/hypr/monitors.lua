-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and supported resolutions with: hyprctl monitors all

-- Ojo: el catch-all no usa la forma de la plantilla (`local omarchy_monitor_scale`
-- ni `output = "", mode = ..., scale = N` en ese orden) a propósito. Así
-- omarchy-hyprland-monitor-scaling (SUPER+/) no lo reescribe: si escribe aquí,
-- Hyprland se autorecarga, la regla del AOC vuelve a 1.25 y el cambio no dura
-- ni un segundo (y de paso la escala acaba también en el portátil). Sin
-- escribir, SUPER+/ cambia la escala en vivo hasta el próximo reload o
-- reconexión, y al conectar cada monitor arranca con su escala de aquí.
hl.env("GDK_SCALE", "1")
hl.monitor({ output = "", scale = 1, mode = "preferred", position = "auto" })

-- AOC 32" 4K: un poco más grande que el resto. Por descripción, no por
-- conector, para que valga sea cual sea el puerto (DP-1, DP-2...).
hl.monitor({ output = "desc:AOC U32U3CV AUJS19A000121", mode = "preferred", position = "auto", scale = 1.25 })

-- Configure a specific monitor.
-- hl.monitor({ output = "DP-2", mode = "2560x1440@144", position = "0x0", scale = 1 })

-- Portrait/rotated secondary monitor (transform: 1 = 90°, 3 = 270°).
-- hl.monitor({ output = "DP-2", mode = "preferred", position = "auto", scale = 1, transform = 1 })
