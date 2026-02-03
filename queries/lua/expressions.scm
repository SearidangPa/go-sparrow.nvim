(function_call
  name: (dot_index_expression
    table: (_)
    field: (identifier) @func_name
  ))

(function_call
  name: (identifier) @func_name
  arguments: (arguments))

(function_call
  name: (method_index_expression
    table: (_)
    method: (identifier) @func_name))
