return {
  {
    "saghen/blink.cmp",
    opts = {
      enabled = function()
        -- Desactiva blink en ciertos tipos de archivo
        return not vim.tbl_contains({ "markdown", "text", "tex" }, vim.bo.filetype)
            and vim.bo.buftype ~= "prompt"
      end,
    },
  },
}
