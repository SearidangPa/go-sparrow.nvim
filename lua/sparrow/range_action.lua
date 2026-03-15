local M = {}

local HIGHLIGHT_NS = vim.api.nvim_create_namespace 'sparrow_range_action'
local beaver = require 'beaver'

---@return { bufnr: number, name: string, start_row: number, end_row: number }?
local function get_nearest_function()
  local bufnr = vim.api.nvim_get_current_buf()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local row0 = cursor_pos[1] - 1

  local ctx = beaver.enclosing_function(bufnr, row0)
  if not ctx then
    vim.schedule(function() vim.notify('No function found (or treesitter not ready)', vim.log.levels.WARN) end)
    return nil
  end

  return {
    bufnr = bufnr,
    name = ctx.name,
    start_row = ctx.start_row,
    end_row = ctx.end_row,
  }
end

M.yank_function = function()
  local ctx = get_nearest_function()
  if not ctx then
    return
  end

  local lines = vim.api.nvim_buf_get_lines(ctx.bufnr, ctx.start_row, ctx.end_row + 1, false)
  local func_text = table.concat(lines, '\n')
  vim.fn.setreg('*', func_text)

  vim.highlight.range(
    ctx.bufnr,
    HIGHLIGHT_NS,
    'IncSearch',
    { ctx.start_row, 0 },
    { ctx.end_row, #(lines[#lines] or '') }
  )

  vim.defer_fn(
    function()
      vim.api.nvim_buf_clear_namespace(ctx.bufnr, HIGHLIGHT_NS, 0, -1)
    end,
    100
  )

  if ctx.name ~= '' then
    vim.notify('Yanked function: ' .. ctx.name)
  else
    vim.notify 'Yanked function'
  end
end

M.visual_function = function()
  local ctx = get_nearest_function()
  if not ctx then
    return
  end

  vim.api.nvim_win_set_cursor(0, { ctx.start_row + 1, 0 })
  vim.cmd 'normal! V'
  vim.api.nvim_win_set_cursor(0, { ctx.end_row + 1, 0 })
end

M.delete_function = function()
  M.visual_function()
  vim.cmd 'normal! d'
end

return M
