(short_var_declaration
  left: (expression_list)
  right: (expression_list
    (call_expression
      function: [
        (identifier) @func_name
        (selector_expression
          field: (field_identifier) @func_name)
      ])))

(assignment_statement
  left: (expression_list)
  right: (expression_list
    (call_expression
      function: [
        (identifier) @func_name
        (selector_expression
          field: (field_identifier) @func_name)
      ])))

(assignment_statement
  right: (expression_list
    (call_expression
      function: (selector_expression
        field: (field_identifier) @func_name))))
