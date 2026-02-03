(variable_declaration
  (assignment_statement
    (variable_list
      name: (identifier))
    (expression_list
      value: (function_call
        name: [
          (identifier) @func_name
          (dot_index_expression
            field: (identifier) @func_name)
          (method_index_expression
            method: (identifier) @func_name)
        ]
      )
    )
  )
)
