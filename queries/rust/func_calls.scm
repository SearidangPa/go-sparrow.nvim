(let_declaration
  value: [
    (call_expression
      function: [
        (identifier) @func_name
        (scoped_identifier) @func_name
        (field_expression) @func_name
        (generic_function) @func_name
      ])
    (try_expression
      (call_expression
        function: [
          (identifier) @func_name
          (scoped_identifier) @func_name
          (field_expression) @func_name
          (generic_function) @func_name
        ]))
    (await_expression
      (call_expression
        function: [
          (identifier) @func_name
          (scoped_identifier) @func_name
          (field_expression) @func_name
          (generic_function) @func_name
        ]))
    (try_expression
      (await_expression
        (call_expression
          function: [
            (identifier) @func_name
            (scoped_identifier) @func_name
            (field_expression) @func_name
            (generic_function) @func_name
          ])))
    (call_expression
      function: (field_expression
        value: (await_expression
          (call_expression
            function: [
              (identifier) @func_name
              (scoped_identifier) @func_name
              (field_expression) @func_name
              (generic_function) @func_name
            ]))))
    (try_expression
      (call_expression
        function: (field_expression
          value: (await_expression
            (call_expression
              function: [
                (identifier) @func_name
                (scoped_identifier) @func_name
                (field_expression) @func_name
                (generic_function) @func_name
              ])))))
  ])

(assignment_expression
  right: [
    (call_expression
      function: [
        (identifier) @func_name
        (scoped_identifier) @func_name
        (field_expression) @func_name
        (generic_function) @func_name
      ])
    (try_expression
      (call_expression
        function: [
          (identifier) @func_name
          (scoped_identifier) @func_name
          (field_expression) @func_name
          (generic_function) @func_name
        ]))
    (await_expression
      (call_expression
        function: [
          (identifier) @func_name
          (scoped_identifier) @func_name
          (field_expression) @func_name
          (generic_function) @func_name
        ]))
    (try_expression
      (await_expression
        (call_expression
          function: [
            (identifier) @func_name
            (scoped_identifier) @func_name
            (field_expression) @func_name
            (generic_function) @func_name
          ])))
    (call_expression
      function: (field_expression
        value: (await_expression
          (call_expression
            function: [
              (identifier) @func_name
              (scoped_identifier) @func_name
              (field_expression) @func_name
              (generic_function) @func_name
            ]))))
    (try_expression
      (call_expression
        function: (field_expression
          value: (await_expression
            (call_expression
              function: [
                (identifier) @func_name
                (scoped_identifier) @func_name
                (field_expression) @func_name
                (generic_function) @func_name
              ])))))
  ])

(let_condition
  value: [
    (call_expression
      function: [
        (identifier) @func_name
        (scoped_identifier) @func_name
        (field_expression) @func_name
        (generic_function) @func_name
      ])
    (try_expression
      (call_expression
        function: [
          (identifier) @func_name
          (scoped_identifier) @func_name
          (field_expression) @func_name
          (generic_function) @func_name
        ]))
    (await_expression
      (call_expression
        function: [
          (identifier) @func_name
          (scoped_identifier) @func_name
          (field_expression) @func_name
          (generic_function) @func_name
        ]))
    (try_expression
      (await_expression
        (call_expression
          function: [
            (identifier) @func_name
            (scoped_identifier) @func_name
            (field_expression) @func_name
            (generic_function) @func_name
          ])))
    (call_expression
      function: (field_expression
        value: (await_expression
          (call_expression
            function: [
              (identifier) @func_name
              (scoped_identifier) @func_name
              (field_expression) @func_name
              (generic_function) @func_name
            ]))))
    (try_expression
      (call_expression
        function: (field_expression
          value: (await_expression
            (call_expression
              function: [
                (identifier) @func_name
                (scoped_identifier) @func_name
                (field_expression) @func_name
                (generic_function) @func_name
              ])))))
  ])
