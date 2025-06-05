local M = {}

local func_decl = require 'go_nav_func_decl'
local func_expr = require 'go_nav_func_expr'
local func_equal = require 'go_nav_func_equal'

M.next_function_declaration = func_decl.next_function_declaration
M.prev_function_declaration = func_decl.prev_function_declaration

M.next_expression_statement = func_expr.next_expression_statement
M.prev_expression_statement = func_expr.prev_expression_statement

M.next_function_call = func_equal.next_function_call
M.prev_function_call = func_equal.prev_function_call
M.repeat_function_call_motion = func_equal.repeat_function_call_motion

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
    vim.keymap.set(
      'n',
      opts.repeat_function_call_motion or '\\',
      M.repeat_function_call_motion,
      vim.tbl_extend('force', keymap_opts, { desc = 'Repeat last function call motion' })
    )
  end
end

return M
