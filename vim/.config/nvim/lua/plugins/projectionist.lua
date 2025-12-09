return {
  {
    "tpope/vim-projectionist",
    config = function()
      -- We translate your old Vimscript configuration to Lua.
      -- This defines the relationship between lib/*.ex and test/*_test.exs
      vim.g.projectionist_heuristics = {
        ["mix.exs"] = {
          ["apps/*/mix.exs"] = { type = "mix" },
          ["lib/*.ex"] = {
            type = "lib",
            alternate = "test/{}_test.exs",
            template = { "defmodule {camelcase|capitalize|dot} do", "end" },
          },
          ["test/*_test.exs"] = {
            type = "test",
            alternate = "lib/{}.ex",
            template = {
              "defmodule {camelcase|capitalize|dot}Test do",
              "  use ExUnit.Case",
              "",
              "  alias {camelcase|capitalize|dot}, as: Subject",
              "",
              "  doctest Subject",
              "end",
            },
          },
          ["mix.exs"] = { type = "mix" },
          ["config/*.exs"] = { type = "config" },
        },
      }
    end,
  },
}
