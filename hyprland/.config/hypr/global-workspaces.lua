-- Escritorios globales, como antes de Omarchy 4.5.
--
-- 4.5 trajo escritorios por monitor (default/hypr/monitor-workspaces.lua): cada
-- monitor físico tiene su bloque de diez ids (portátil 1-10, AOC 11-20) y, al
-- cambiar de pantalla, Omarchy renumera y mueve escritorios entre bloques. Aquí
-- se usa una sola pantalla cada vez (portátil abierto, o cerrado con el AOC), así
-- que eso solo estorba: escritorios que cambian de número, "invitados" en la
-- barra, y las reglas de windowrules.lua (que nombran ids globales) mandando
-- ventanas —los menús de Bambu Studio, p. ej.— a un escritorio que no es el suyo.
--
-- Replica el modo apagado de la PR omacom/omarchy#16213, que añade
-- `omarchy toggle monitor-workspaces off`. Cuando se fusione: borrar este
-- archivo y su require en hyprland.lua, y usar el toggle.
--
-- Se apoya en que Omarchy busca estas funciones en o.workspaces al llamarlas, no
-- al cargar. Si un update las renombra no se rompe nada: se vuelve sin más al
-- modo por monitor (la señal: escritorios 11-20 con el AOC).

local state = require("default.hypr.paths").state_home .. "/omarchy/"

-- SUPER+N, SUPER+SHIFT+N y los clics de la barra: el escritorio N, sea cual sea
-- la pantalla.
o.workspaces.workspace_id = function(_, slot)
  return slot
end

-- Sin reordenar escritorios al arrancar, al recargar ni al (des)conectar monitores.
o.workspaces.reconcile = function() end

-- La barra lee de aquí el bloque de cada monitor; vacío, cada barra cae al bloque
-- del escritorio que muestra, o sea 1-10. Y fuera los orígenes de escritorios
-- fusionados, que ya nadie va a restaurar. Se repite al cambiar de monitor por si
-- algo de Omarchy lo reescribió con las dos pantallas encendidas un momento.
local function forget_blocks()
  local file = io.open(state .. "monitor-workspaces", "w")
  if file then
    file:close()
  end
  os.remove(state .. "monitor-workspaces-merged")
end

forget_blocks()
hl.on("monitor.added", forget_blocks)
hl.on("monitor.removed", forget_blocks)
