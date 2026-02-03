local M = {}

M.next_function_declaration = function(opts)
  return require('go-sparrow.go_nav_func_decl').next_func_declaration(opts)
end

M.prev_function_declaration = function(opts)
  return require('go-sparrow.go_nav_func_decl').prev_func_declaration(opts)
end

M.next_function_call = function()
  return require('go-sparrow.go_nav_func_equal').next_function_call()
end

M.prev_function_call = function()
  return require('go-sparrow.go_nav_func_equal').prev_function_call()
end

M.next_identifier = function()
  return require('go-sparrow.go_nav_identifier').next_identifier()
end

M.prev_identifier = function()
  return require('go-sparrow.go_nav_identifier').prev_identifier()
end

M.next_expression = function()
  return require('go-sparrow.go_nav_func_equal').next_expression()
end

M.prev_expression = function()
  return require('go-sparrow.go_nav_func_equal').prev_expression()
end

M.setup = function() end

return M
