(expression_statement
  (call_expression
    function: [
      (identifier) @func_name
      (selector_expression
        field: (field_identifier) @func_name)
    ]))

(go_statement
  (call_expression
    function: [
      (identifier) @func_name
      (selector_expression
        field: (field_identifier) @func_name)
    ]))

(return_statement
  (expression_list
    (call_expression
      function: [
        (identifier) @func_name
        (selector_expression
          field: (field_identifier) @func_name)
      ])))
