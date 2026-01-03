return {
  "folke/snacks.nvim",
  keys = {
    {
      "<leader>rr",
      function()
        require("config.send-terminal").send_line()
      end,
      desc = "Send line to terminal",
    },
    {
      "<leader>r",
      function()
        return require("config.send-terminal").send_operator()
      end,
      expr = true,
      desc = "Send to terminal",
    },
    {
      "<leader>r",
      function()
        require("config.send-terminal").send_visual()
      end,
      mode = "x",
      desc = "Send selection to terminal",
    },
  },
}
