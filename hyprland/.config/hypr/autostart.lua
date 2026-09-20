-- Extra autostart processes.
-- o.launch_on_start("my-service")

-- Silencia las notificaciones mientras compartes pantalla (ver el script para
-- la mecánica). No hay equivalente de serie en quattro: `SUPER+CTRL+coma` silencia
-- a mano, pero nada reacciona al portal de screencast.
--
-- Va por `launch_on_start` (o sea uwsm-app) y no por `exec_on_start` como en
-- Omarchy 3: es un demonio de sesión, y así systemd lo recoge al cerrar sesión
-- en vez de dejarlo colgando como hijo de Hyprland.
-- La ruta se compone en Lua en vez de dejar un "$HOME" a que lo expanda el
-- shell de `exec`: así no depende de cómo cite Hyprland el comando.
local config_home = os.getenv("XDG_CONFIG_HOME") or (os.getenv("HOME") .. "/.config")
o.launch_on_start(config_home .. "/hypr/scripts/screencast-dnd")
