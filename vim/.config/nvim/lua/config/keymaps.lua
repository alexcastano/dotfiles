-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- Remap ; to enter Command Mode (replaces default :)
map({ "n", "v" }, ";", ":", { desc = "Enter Command Mode" })

-- Note: We do NOT map ":" here manually because we want
-- the Flash plugin to handle that key for navigation.
