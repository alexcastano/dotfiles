return {
  "folke/snacks.nvim",
  opts = {
    terminal = {
      win = {
        position = "right",
        width = 100, -- Fixed width in characters
      },
    },
    picker = {
      sources = {
        files = {
          hidden = true,
        },
      },
    },
  },
}
