local M = {}

local func_decl = require 'go-sparrow.go_nav_func_decl'
local func_equal = require 'go-sparrow.go_nav_func_equal'
local nav_identifier = require 'go-sparrow.go_nav_identifier'

M.next_function_declaration = func_decl.next_func_declaration
M.prev_function_declaration = func_decl.prev_func_declaration

M.next_function_call = func_equal.next_function_call
M.prev_function_call = func_equal.prev_function_call

M.next_identifier = nav_identifier.next_identifier
M.prev_identifier = nav_identifier.prev_identifier

M.next_expression = func_equal.next_expression
M.prev_expression = func_equal.prev_expression


M.setup = function() end

return M
