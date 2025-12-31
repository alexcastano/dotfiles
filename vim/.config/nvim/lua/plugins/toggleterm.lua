return {
  {
    "akinsho/toggleterm.nvim",
    keys = {
      {
        "<C-space>j",
        function()
          vim.cmd(vim.v.count1 .. "ToggleTerm direction=horizontal")
        end,
        mode = { "n", "t" },
        desc = "Toggle terminal (bottom)",
      },
      {
        "<C-space>l",
        function()
          vim.cmd(vim.v.count1 .. "ToggleTerm direction=vertical")
        end,
        mode = { "n", "t" },
        desc = "Toggle terminal (right)",
      },
      {
        "<C-space>k",
        function()
          vim.cmd(vim.v.count1 .. "ToggleTerm direction=float")
        end,
        mode = { "n", "t" },
        desc = "Toggle terminal (float)",
      },
      {
        "<C-space>t",
        function()
          vim.cmd(vim.v.count1 .. "ToggleTerm direction=tab")
        end,
        mode = { "n", "t" },
        desc = "Toggle terminal (tab)",
      },
    },
    opts = {
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        end
      end,
    },
  },
}
