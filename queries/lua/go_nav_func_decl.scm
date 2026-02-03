(function_declaration
  name: (identifier) @func_decl_start
) @func_node

(function_declaration
  name: (dot_index_expression
    field: (identifier) @func_decl_start)
) @func_node

(function_declaration
  name: (method_index_expression
    table: (identifier)
    method: (identifier) @func_decl_start)
) @func_node

(variable_declaration
  (assignment_statement
    (variable_list
      name: (identifier) @func_decl_start
    )
    (expression_list
      value: (function_definition)
    )
  )
) @func_node

(assignment_statement
  (variable_list
    name: (dot_index_expression
      field: (identifier) @func_decl_start)
  )
  (expression_list
    value: (function_definition)
  )
) @func_node
