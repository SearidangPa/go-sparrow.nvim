local M = {}

local function get_query()
  local lang = vim.treesitter.language.get_lang(vim.bo.filetype)
  assert(lang, 'Language is nil')

  local query
  if lang == 'lua' then
    query = vim.treesitter.query.parse(
      lang,
      [[
      (function_declaration
        name: (identifier) @func_decl_start
      )@func_node

      (function_declaration
        name: (dot_index_expression
          field: (identifier) @func_decl_start)
      )@func_node

      (function_declaration
        name: (method_index_expression
          table: (identifier)
          method: (identifier) @func_decl_start)
      )@func_node


      (variable_declaration
        (assignment_statement
           (variable_list
             name: (identifier) @func_decl_start
           )
           (expression_list
           	value: (function_definition)
           )
        )
      )@func_node


      (assignment_statement
        (variable_list
          name: (dot_index_expression
            field: (identifier) @func_decl_start)
        )
        (expression_list
          value: (function_definition)
        )
      )@func_node
    ]]
    )
  elseif lang == 'go' then
    query = vim.treesitter.query.parse(
      lang,
      [[
        (function_declaration
          name: (identifier) @func_decl_start
        )
        (method_declaration
        name: (field_identifier) @func_decl_start
        )
      ]]
    )
  elseif lang == 'zig' then
    query = vim.treesitter.query.parse(
      lang,
      [[
        (function_declaration
          name: (identifier) @func_decl_start
        )
      ]]
    )
  end
  return query
end

local function get_root_and_query()
  local root = require('go-sparrow.util_treesitter').get_root_node()
  local query = get_query()
  return root, query
end

local function find_next_func_declaration(root, query, cursor_row, cursor_col, skip_one)
  local row_to_pass = cursor_row

  for id, node in query:iter_captures(root, 0, 0, -1) do
    assert(node, "node is nil")
    local name = query.captures[id] -- name of the capture in the query
    local s_row, s_col, e_row, _ = node:range()

    if name == "func_node" and skip_one then
      if e_row > row_to_pass then
        skip_one = false
        row_to_pass = e_row
      end
      goto continue
    end

    if name == "func_decl_start" then
      if s_row > row_to_pass or (s_row == row_to_pass and s_col > cursor_col) then
        return node
      end
    end
    ::continue::
  end
  return nil
end


M.next_func_declaration = function(opts)
  local skip_one = opts and opts.skip_one or false
  local count = vim.v.count
  if count == 0 then
    count = 1
  end
  local root, query = get_root_and_query()
  for _ = 1, count do
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    local current_row, current_col = cursor_pos[1] - 1, cursor_pos[2]
    local next_node = find_next_func_declaration(root, query, current_row, current_col, skip_one)

    if next_node then
      local start_row, start_col, _, _ = next_node:range()
      vim.api.nvim_win_set_cursor(0, { start_row + 1, start_col })
      current_row = start_row
    end
  end
end

---@return TSNode|nil
M.find_prev_func_declaration = function(root, query, cursor_row, cursor_col, outer_most)
  outer_most = outer_most or false
  local top_line, bottom_line = require('go-sparrow.util_treesitter').get_visible_range()
  local previous_node = nil

  -- First search in visible range
  for id, node, _, _ in query:iter_captures(root, 0, top_line, bottom_line) do
    assert(node, "node is nil")
    local name = query.captures[id] -- name of the capture in the query
    if name == "func_decl_start" then
      local s_row, s_col, _ = node:start()
      if s_row < cursor_row or (s_row == cursor_row and s_col < cursor_col) then
        if not previous_node then
          previous_node = node
        else
          local prev_s_row, _, _ = previous_node:start()
          if s_row > prev_s_row then
            previous_node = node
          end
        end
      end
    end
    if outer_most and name == "func_node" then
      local _, _, e_row, _ = node:start()
      if e_row > cursor_row then
        for child in node:iter_children() do
          if child:type() == "identifier" then
            return child
          end
        end
        return node
      end
    end
  end

  if previous_node then
    return previous_node
  end

  -- Fallback to full search from beginning to cursor
  for id, node, _, _ in query:iter_captures(root, 0, 0, cursor_row) do
    assert(node, "node is nil")
    local name = query.captures[id] -- name of the capture in the query
    if name == "func_decl_start" then
      local s_row, s_col, _ = node:start()
      if s_row < cursor_row or (s_row == cursor_row and s_col < cursor_col) then
        if not previous_node then
          previous_node = node
        else
          local prev_s_row, _, _ = previous_node:start()
          if s_row > prev_s_row then
            previous_node = node
          end
        end
      end
    end
  end

  return previous_node
end

M.prev_func_declaration = function(opts)
  local outer_most = opts and opts.outer_most or false
  local count = vim.v.count
  if count == 0 then
    count = 1
  end
  local root, query = get_root_and_query()
  for _ = 1, count do
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    local current_row = cursor_pos[1] - 1
    local current_col = cursor_pos[2]
    local previous_node = M.find_prev_func_declaration(root, query, current_row, current_col, outer_most)
    if previous_node then
      local start_row, start_col, _, _ = previous_node:range()
      vim.api.nvim_win_set_cursor(0, { start_row + 1, start_col })
      current_row = start_row
    end
  end
end



return M
