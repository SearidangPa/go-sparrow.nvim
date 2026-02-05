(let_declaration
  value: (call_expression
    function: (identifier) @func_name))

(let_declaration
  value: (call_expression
    function: (scoped_identifier
      name: (identifier) @func_name)))

(let_declaration
  value: (call_expression
    function: (field_expression
      field: (field_identifier) @func_name)))

(let_declaration
  value: (call_expression
    function: (generic_function
      function: (identifier) @func_name)))

(let_declaration
  value: (call_expression
    function: (generic_function
      function: (scoped_identifier
        name: (identifier) @func_name))))

(let_declaration
  value: (call_expression
    function: (generic_function
      function: (field_expression
        field: (field_identifier) @func_name))))

(assignment_expression
  right: (call_expression
    function: (identifier) @func_name))

(assignment_expression
  right: (call_expression
    function: (scoped_identifier
      name: (identifier) @func_name)))

(assignment_expression
  right: (call_expression
    function: (field_expression
      field: (field_identifier) @func_name)))

(assignment_expression
  right: (call_expression
    function: (generic_function
      function: (identifier) @func_name)))

(assignment_expression
  right: (call_expression
    function: (generic_function
      function: (scoped_identifier
        name: (identifier) @func_name))))

(assignment_expression
  right: (call_expression
    function: (generic_function
      function: (field_expression
        field: (field_identifier) @func_name))))
