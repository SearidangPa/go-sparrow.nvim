local M = {}

-- Lazy module loading: modules are only required on first use
local _func_decl, _func_equal, _nav_identifier

M.next_function_declaration = function(opts)
  _func_decl = _func_decl or require 'go-sparrow.go_nav_func_decl'
  return _func_decl.next_func_declaration(opts)
end

M.prev_function_declaration = function(opts)
  _func_decl = _func_decl or require 'go-sparrow.go_nav_func_decl'
  return _func_decl.prev_func_declaration(opts)
end

M.next_function_call = function()
  _func_equal = _func_equal or require 'go-sparrow.go_nav_func_equal'
  return _func_equal.next_function_call()
end

M.prev_function_call = function()
  _func_equal = _func_equal or require 'go-sparrow.go_nav_func_equal'
  return _func_equal.prev_function_call()
end

M.next_identifier = function()
  _nav_identifier = _nav_identifier or require 'go-sparrow.go_nav_identifier'
  return _nav_identifier.next_identifier()
end

M.prev_identifier = function()
  _nav_identifier = _nav_identifier or require 'go-sparrow.go_nav_identifier'
  return _nav_identifier.prev_identifier()
end

M.next_expression = function()
  _func_equal = _func_equal or require 'go-sparrow.go_nav_func_equal'
  return _func_equal.next_expression()
end

M.prev_expression = function()
  _func_equal = _func_equal or require 'go-sparrow.go_nav_func_equal'
  return _func_equal.prev_expression()
end

M.setup = function() end

return M
