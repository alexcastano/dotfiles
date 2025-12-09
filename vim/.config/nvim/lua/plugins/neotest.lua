return {
  {
    "nvim-neotest/neotest",
    keys = {
      {
        "<leader>tF",
        function()
          -- Runs the full suite (project root) with the '--failed' flag
          require("neotest").run.run({ suite = true, extra_args = { "--failed", "--trace" } })
        end,
        desc = "Run Failed Tests (mix test --failed)",
      },
    },
    opts = {
      -- output = { open_on_run = true },
      -- Configure the Output Panel (logs/results)
      output_panel = {
        -- enabled = true,
        -- 'botright' forces it to the far right
        -- 'vsplit' makes it vertical
        -- 'vertical resize 50' sets the width
        open = "botright vsplit | vertical resize 100",
      },
    },
  },
}
