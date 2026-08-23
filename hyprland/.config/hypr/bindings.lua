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
