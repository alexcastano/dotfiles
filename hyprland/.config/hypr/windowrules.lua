-- Workspace assignments: apps that always belong in the same place.
-- `silent` means they land there without dragging the focus along.

o.window("Spotify", { workspace = "10 silent" })
o.window("slack", { workspace = "9 silent" })
o.window("chrome-web.whatsapp.com__-Default", { workspace = "9 silent" })
o.window("teams-for-linux", { workspace = "8 silent" })
o.window("zen", { workspace = "5 silent" })
o.window("chrome-web.telegram.org__-Default", { workspace = "3 silent" })
o.window("com.t3tools.T3Code", { workspace = "3 silent" })
-- Omarchy turns focus_on_activate on globally, so if Bambu Studio requests
-- activation (splash → main window, dialogs) it would yank you to 4 despite `silent`.
o.window("BambuStudio", { workspace = "4 silent", focus_on_activate = false })
