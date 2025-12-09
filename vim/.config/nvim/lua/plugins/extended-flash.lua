return {
  {
    "folke/flash.nvim",
    -- We define global keymaps here.
    -- This is what actually makes the key "do" something.
    keys = {
      {
        ":",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump({ continue = true })
        end,
        desc = "Flash Next Match (was ;)",
      },
    },
    -- We update opts to ensure the internal engine recognizes the new keys
    opts = {
      modes = {
        char = {
          -- We remove ";" and add ":" to the allowed trigger keys
          keys = { "f", "F", "t", "T", ",", ":" },
        },
      },
    },
  },
}
