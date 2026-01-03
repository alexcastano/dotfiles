local M = {}

--- Get or create the default terminal (the one opened with C-/)
---@return snacks.win
function M.get_terminal()
  return Snacks.terminal.get(nil, { cwd = LazyVim.root() })
end

--- Send text to the terminal
---@param text string
---@param opts? { newline?: boolean }
function M.send(text, opts)
  opts = opts or {}
  local terminal = M.get_terminal()
  if not terminal or not terminal.buf then
    vim.notify("Failed to get terminal", vim.log.levels.ERROR)
    return
  end

  local channel = vim.b[terminal.buf].terminal_job_id
  if not channel then
    vim.notify("Terminal has no job channel", vim.log.levels.ERROR)
    return
  end

  local suffix = opts.newline and "\n" or ""
  vim.fn.chansend(channel, text .. suffix)
end

--- Send current line to terminal (with newline to execute)
function M.send_line()
  local line = vim.api.nvim_get_current_line()
  M.send(line, { newline = true })
end

--- Operator function - returns g@ to trigger operatorfunc
---@return string
function M.send_operator()
  vim.o.operatorfunc = "v:lua.require'config.send-terminal'.operator_callback"
  return "g@"
end

--- Callback for operator motion
---@param type string "line"|"char"|"block"
function M.operator_callback(type)
  local start_pos = vim.api.nvim_buf_get_mark(0, "[")
  local end_pos = vim.api.nvim_buf_get_mark(0, "]")

  local lines
  if type == "line" then
    lines = vim.api.nvim_buf_get_lines(0, start_pos[1] - 1, end_pos[1], false)
  else
    lines = vim.api.nvim_buf_get_text(0, start_pos[1] - 1, start_pos[2], end_pos[1] - 1, end_pos[2] + 1, {})
  end

  local text = table.concat(lines, "\n")
  M.send(text, { newline = false })
end

--- Send visual selection to terminal
function M.send_visual()
  -- Exit visual mode to set marks
  vim.cmd("normal! ")

  local start_pos = vim.api.nvim_buf_get_mark(0, "<")
  local end_pos = vim.api.nvim_buf_get_mark(0, ">")
  local mode = vim.fn.visualmode()

  local lines
  if mode == "V" then
    lines = vim.api.nvim_buf_get_lines(0, start_pos[1] - 1, end_pos[1], false)
  elseif mode == "v" then
    lines = vim.api.nvim_buf_get_text(0, start_pos[1] - 1, start_pos[2], end_pos[1] - 1, end_pos[2] + 1, {})
  else
    -- Block mode - get each line's selected portion
    lines = {}
    for lnum = start_pos[1], end_pos[1] do
      local line = vim.api.nvim_buf_get_lines(0, lnum - 1, lnum, false)[1]
      local start_col = math.min(start_pos[2], #line)
      local end_col = math.min(end_pos[2] + 1, #line)
      table.insert(lines, line:sub(start_col + 1, end_col))
    end
  end

  local text = table.concat(lines, "\n")
  M.send(text, { newline = false })
end

return M
