(expression_statement
  (call_expression
    function: (identifier) @func_name))

(expression_statement
  (call_expression
    function: (scoped_identifier
      name: (identifier) @func_name)))

(expression_statement
  (call_expression
    function: (field_expression
      field: (field_identifier) @func_name)))

(expression_statement
  (call_expression
    function: (generic_function
      function: (identifier) @func_name)))

(expression_statement
  (call_expression
    function: (generic_function
      function: (scoped_identifier
        name: (identifier) @func_name))))

(expression_statement
  (call_expression
    function: (generic_function
      function: (field_expression
        field: (field_identifier) @func_name))))

(return_expression
  (call_expression
    function: (identifier) @func_name))

(return_expression
  (call_expression
    function: (scoped_identifier
      name: (identifier) @func_name)))

(return_expression
  (call_expression
    function: (field_expression
      field: (field_identifier) @func_name)))

(return_expression
  (call_expression
    function: (generic_function
      function: (identifier) @func_name)))

(return_expression
  (call_expression
    function: (generic_function
      function: (scoped_identifier
        name: (identifier) @func_name))))

(return_expression
  (call_expression
    function: (generic_function
      function: (field_expression
        field: (field_identifier) @func_name))))
