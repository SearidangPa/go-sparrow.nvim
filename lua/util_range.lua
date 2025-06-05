local M = {}

function M.get_visible_range()
  local win = vim.api.nvim_get_current_win()
  local top_line = vim.fn.line('w0', win) - 1 -- 0-indexed
  local bottom_line = vim.fn.line('w$', win) - 1 -- 0-indexed
  return top_line, bottom_line
end

return M
