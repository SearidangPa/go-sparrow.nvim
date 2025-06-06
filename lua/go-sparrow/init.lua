local M = {}

local func_decl = require 'go-sparrow.go_nav_func_decl'
local func_expr = require 'go-sparrow.go_nav_func_expr'
local func_equal = require 'go-sparrow.go_nav_func_equal'
local repeat_motion = require 'go-sparrow.repeat_motion'

M.next_function_declaration = func_decl.next_function_declaration
M.prev_function_declaration = func_decl.prev_function_declaration

M.next_expression_statement = func_expr.next_expression_statement
M.prev_expression_statement = func_expr.prev_expression_statement

M.next_function_call = func_equal.next_function_call
M.prev_function_call = func_equal.prev_function_call

function M.repeat_last_motion()
  if not repeat_motion.has_last_motion() then
    return
  end

  local motion_type, direction, _ = repeat_motion.get_last_motion()

  if motion_type == 'function_declaration' then
    if direction == 'next' then
      func_decl.next_function_declaration()
    elseif direction == 'previous' then
      func_decl.prev_function_declaration()
    end
  elseif motion_type == 'expression_statement' then
    if direction == 'next' then
      func_expr.next_expression_statement()
    elseif direction == 'previous' then
      func_expr.prev_expression_statement()
    end
  elseif motion_type == 'function_call_with_equal' then
    if direction == 'next' then
      func_equal.next_function_call()
    elseif direction == 'previous' then
      func_equal.prev_function_call()
    end
  end
end

function M.setup(opts)
  opts = opts or {}

  if opts.keymaps ~= false then
    local keymap_opts = { silent = true, noremap = true }

    vim.keymap.set(
      'n',
      opts.next_function_declaration or ']m',
      M.next_function_declaration,
      vim.tbl_extend('force', keymap_opts, { desc = 'Next function declaration' })
    )
    vim.keymap.set(
      'n',
      opts.prev_function_declaration or '[m',
      M.prev_function_declaration,
      vim.tbl_extend('force', keymap_opts, { desc = 'Previous function declaration' })
    )

    vim.keymap.set(
      'n',
      opts.next_expression_statement or ']e',
      M.next_expression_statement,
      vim.tbl_extend('force', keymap_opts, { desc = 'Next expression statement' })
    )
    vim.keymap.set(
      'n',
      opts.prev_expression_statement or '[e',
      M.prev_expression_statement,
      vim.tbl_extend('force', keymap_opts, { desc = 'Previous expression statement' })
    )

    vim.keymap.set('n', opts.next_function_call or ']f', M.next_function_call, vim.tbl_extend('force', keymap_opts, { desc = 'Next function call' }))
    vim.keymap.set('n', opts.prev_function_call or '[f', M.prev_function_call, vim.tbl_extend('force', keymap_opts, { desc = 'Previous function call' }))
    vim.keymap.set('n', opts.repeat_last_motion or '\\', M.repeat_last_motion, vim.tbl_extend('force', keymap_opts, { desc = 'Repeat last motion' }))
  end
end

return M
