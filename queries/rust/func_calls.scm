(let_declaration
  value: [
    (call_expression
      function: [
        (identifier) @func_name
        (scoped_identifier
          name: (identifier) @func_name)
        (field_expression
          field: (field_identifier) @func_name)
        (generic_function
          function: (identifier) @func_name)
        (generic_function
          function: (scoped_identifier
            name: (identifier) @func_name))
        (generic_function
          function: (field_expression
            field: (field_identifier) @func_name))
      ])
    (try_expression
      (call_expression
        function: [
          (identifier) @func_name
          (scoped_identifier
            name: (identifier) @func_name)
          (field_expression
            field: (field_identifier) @func_name)
          (generic_function
            function: (identifier) @func_name)
          (generic_function
            function: (scoped_identifier
              name: (identifier) @func_name))
          (generic_function
            function: (field_expression
              field: (field_identifier) @func_name))
        ]))
    (await_expression
      (call_expression
        function: [
          (identifier) @func_name
          (scoped_identifier
            name: (identifier) @func_name)
          (field_expression
            field: (field_identifier) @func_name)
          (generic_function
            function: (identifier) @func_name)
          (generic_function
            function: (scoped_identifier
              name: (identifier) @func_name))
          (generic_function
            function: (field_expression
              field: (field_identifier) @func_name))
        ]))
    (try_expression
      (await_expression
        (call_expression
          function: [
            (identifier) @func_name
            (scoped_identifier
              name: (identifier) @func_name)
            (field_expression
              field: (field_identifier) @func_name)
            (generic_function
              function: (identifier) @func_name)
            (generic_function
              function: (scoped_identifier
                name: (identifier) @func_name))
            (generic_function
              function: (field_expression
                field: (field_identifier) @func_name))
          ])))
    (call_expression
      function: (field_expression
        value: (await_expression
          (call_expression
            function: [
              (identifier) @func_name
              (scoped_identifier
                name: (identifier) @func_name)
              (field_expression
                field: (field_identifier) @func_name)
              (generic_function
                function: (identifier) @func_name)
              (generic_function
                function: (scoped_identifier
                  name: (identifier) @func_name))
              (generic_function
                function: (field_expression
                  field: (field_identifier) @func_name))
            ]))))
    (try_expression
      (call_expression
        function: (field_expression
          value: (await_expression
            (call_expression
              function: [
                (identifier) @func_name
                (scoped_identifier
                  name: (identifier) @func_name)
                (field_expression
                  field: (field_identifier) @func_name)
                (generic_function
                  function: (identifier) @func_name)
                (generic_function
                  function: (scoped_identifier
                    name: (identifier) @func_name))
                (generic_function
                  function: (field_expression
                    field: (field_identifier) @func_name))
              ])))))
  ])

(assignment_expression
  right: [
    (call_expression
      function: [
        (identifier) @func_name
        (scoped_identifier
          name: (identifier) @func_name)
        (field_expression
          field: (field_identifier) @func_name)
        (generic_function
          function: (identifier) @func_name)
        (generic_function
          function: (scoped_identifier
            name: (identifier) @func_name))
        (generic_function
          function: (field_expression
            field: (field_identifier) @func_name))
      ])
    (try_expression
      (call_expression
        function: [
          (identifier) @func_name
          (scoped_identifier
            name: (identifier) @func_name)
          (field_expression
            field: (field_identifier) @func_name)
          (generic_function
            function: (identifier) @func_name)
          (generic_function
            function: (scoped_identifier
              name: (identifier) @func_name))
          (generic_function
            function: (field_expression
              field: (field_identifier) @func_name))
        ]))
    (await_expression
      (call_expression
        function: [
          (identifier) @func_name
          (scoped_identifier
            name: (identifier) @func_name)
          (field_expression
            field: (field_identifier) @func_name)
          (generic_function
            function: (identifier) @func_name)
          (generic_function
            function: (scoped_identifier
              name: (identifier) @func_name))
          (generic_function
            function: (field_expression
              field: (field_identifier) @func_name))
        ]))
    (try_expression
      (await_expression
        (call_expression
          function: [
            (identifier) @func_name
            (scoped_identifier
              name: (identifier) @func_name)
            (field_expression
              field: (field_identifier) @func_name)
            (generic_function
              function: (identifier) @func_name)
            (generic_function
              function: (scoped_identifier
                name: (identifier) @func_name))
            (generic_function
              function: (field_expression
                field: (field_identifier) @func_name))
          ])))
    (call_expression
      function: (field_expression
        value: (await_expression
          (call_expression
            function: [
              (identifier) @func_name
              (scoped_identifier
                name: (identifier) @func_name)
              (field_expression
                field: (field_identifier) @func_name)
              (generic_function
                function: (identifier) @func_name)
              (generic_function
                function: (scoped_identifier
                  name: (identifier) @func_name))
              (generic_function
                function: (field_expression
                  field: (field_identifier) @func_name))
            ]))))
    (try_expression
      (call_expression
        function: (field_expression
          value: (await_expression
            (call_expression
              function: [
                (identifier) @func_name
                (scoped_identifier
                  name: (identifier) @func_name)
                (field_expression
                  field: (field_identifier) @func_name)
                (generic_function
                  function: (identifier) @func_name)
                (generic_function
                  function: (scoped_identifier
                    name: (identifier) @func_name))
                (generic_function
                  function: (field_expression
                    field: (field_identifier) @func_name))
              ])))))
  ])
