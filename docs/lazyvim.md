# LazyVim Configuration Guide

Standard LazyVim installation. This documents how LazyVim works, not specific plugins.

## Directory Structure

```
~/.config/nvim/
├── lua/config/          # Core configuration (auto-loaded)
│   ├── autocmds.lua     # Event-triggered actions
│   ├── keymaps.lua      # Custom keybindings
│   ├── lazy.lua         # lazy.nvim bootstrap
│   └── options.lua      # Vim options (indentation, etc.)
├── lua/plugins/         # Plugin specs (one file or many)
│   └── *.lua
└── init.lua
```

## Loading Order

1. LazyVim defaults load first
2. Your `lua/config/*.lua` files override/extend them
3. **Never manually require config files** - LazyVim handles this

## Plugin Configuration

All plugin specs go in `lua/plugins/*.lua`. Each file returns a table of specs.

### Adding a Plugin
```lua
return {
  { "author/plugin-name", opts = { ... } },
}
```

### Disabling a Built-in Plugin
```lua
return {
  { "author/plugin-name", enabled = false },
}
```

### Extending a Plugin
LazyVim merges your specs with defaults using these rules:
- **List fields** (`cmd`, `event`, `ft`, `keys`, `dependencies`): values are **appended**
- **`opts`**: deep merged with defaults
- **Other properties**: override entirely

### Modifying opts Dynamically
When merging isn't enough, use a function:
```lua
return {
  {
    "author/plugin-name",
    opts = function(_, opts)
      opts.some_option = "new_value"
      return opts
    end,
  },
}
```

### Keymap Customization
Keymaps in `keys` field are merged. To disable a default keymap:
```lua
keys = {
  { "<leader>xx", false },  -- disable this mapping
}
```

To disable all default keymaps for a plugin, return empty table from `keys` function.

## Plugin Categories

1. **Built-in**: Always loaded (snacks.nvim, which-key, etc.)
2. **Lazy Extras**: Opt-in via `:LazyExtras` - guaranteed compatible
3. **Third-party**: Manual installation, may need conflict resolution

## Keymap System

### Leader Keys
- **Leader**: `<space>`
- **Local Leader**: `\`

### Three Keymap Layers

1. **Global keymaps** (`lua/config/keymaps.lua`): Always active, use `vim.keymap.set`
2. **Plugin keymaps** (`keys` field in spec): Lazy-loaded with the plugin
3. **LSP keymaps** (`opts.servers` in lspconfig): Per-server or global (`servers['*']`)

### Removing Default Keymaps
```lua
-- In lua/config/keymaps.lua
vim.keymap.del("n", "<leader>xx")

-- In plugin spec keys field
keys = { { "<leader>xx", false } }

-- For LSP keymaps (in lspconfig opts)
opts = {
  servers = {
    ["*"] = {
      keys = { { "gd", false } }  -- disable for all servers
    }
  }
}
```

### Keymap Modes
- `n` - Normal mode
- `i` - Insert mode
- `v` - Visual mode
- `x` - Visual mode (excludes select mode)
- `o` - Operator-pending mode (after d, y, c, etc.)
- `c` - Command-line mode
- `s` - Select mode
- `t` - Terminal mode

### Default Keymaps Reference
See https://www.lazyvim.org/keymaps for the full list.

## Plugin Installation Path

Plugins are installed at `~/.local/share/nvim/lazy/<plugin-name>/`. Documentation is typically at:
- `doc/<plugin>.txt` - Vim help file
- `README.md` - GitHub readme

## Useful Commands

- `:Lazy` - Plugin manager UI
- `:LazyExtras` - Enable/disable extras
- `:LazyHealth` - Check installation health

## References

- https://www.lazyvim.org/configuration/plugins
- https://www.lazyvim.org/configuration/general
- https://www.lazyvim.org/configuration/keymaps
- https://www.lazyvim.org/keymaps (default keybindings)
- https://lazyvim-ambitious-devs.phillips.codes/course/chapter-5/
