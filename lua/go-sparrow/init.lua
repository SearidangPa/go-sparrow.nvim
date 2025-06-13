local M = {}

local func_decl = require 'go-sparrow.go_nav_func_decl'
local func_expr = require 'go-sparrow.go_nav_func_expr'
local func_equal = require 'go-sparrow.go_nav_func_equal'
local nav_identifier = require 'go-sparrow.go_nav_identifier'

M.next_function_declaration = func_decl.next_function_declaration
M.prev_function_declaration = func_decl.prev_function_declaration

M.next_expression_statement = func_expr.next_expression_statement
M.prev_expression_statement = func_expr.prev_expression_statement

M.next_function_call = func_equal.next_function_call
M.prev_function_call = func_equal.prev_function_call

M.next_identifier = nav_identifier.next_identifier
M.prev_identifier = nav_identifier.prev_identifier

M.setup = function() end

return M
