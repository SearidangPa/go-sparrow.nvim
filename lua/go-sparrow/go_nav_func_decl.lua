local M = {}

local function get_query()
  local lang = vim.treesitter.language.get_lang(vim.bo.filetype)
  assert(lang, 'Language is nil')

  local query
  if lang == 'lua' then
    -- if is_func_start then
    query = vim.treesitter.query.parse(
      lang,
      [[
      (function_declaration
        name: (identifier) @func_decl_start
      )
      (function_declaration
        name: (dot_index_expression
          field: (identifier) @func_decl_start)
      )

      (function_declaration
        name: (method_index_expression
          table: (identifier)
          method: (identifier) @func_decl_start)
      )

      (assignment_statement
        (variable_list
          name: (dot_index_expression
            field: (identifier) @func_decl_start)
        )
        (expression_list
          value: (function_definition)
        )
      )
    ]]
    )
  else
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
  end
  return query
end

local function get_root_and_query()
  local root = require('go-sparrow.util_treesitter').get_root_node()
  local query = get_query()
  return root, query
end

local function find_next_func_declaration(root, query, cursor_row, cursor_col)
  for _, node in query:iter_captures(root, 0, 0, -1) do
    if node then
      local s_row, s_col, _ = node:start()
      if s_row > cursor_row or (s_row == cursor_row and s_col > cursor_col) then
        return node
      end
    end
  end
  return nil
end

M.next_func_declaration = function()
  local count = vim.v.count
  if count == 0 then
    count = 1
  end
  local root, query = get_root_and_query()
  for _ = 1, count do
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    local current_row, current_col = cursor_pos[1] - 1, cursor_pos[2]
    local next_node = find_next_func_declaration(root, query, current_row, current_col)

    if next_node then
      local start_row, start_col, _, _ = next_node:range()
      vim.api.nvim_win_set_cursor(0, { start_row + 1, start_col })
      current_row = start_row
    end
  end
end

---@return TSNode|nil
M.find_prev_func_declaration = function(root, query, cursor_row, cursor_col)
  local top_line, bottom_line = require('go-sparrow.util_treesitter').get_visible_range()
  local previous_node = nil

  -- First search in visible range
  for _, node, _, _ in query:iter_captures(root, 0, top_line, bottom_line) do
    if node then
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

  if previous_node then
    return previous_node
  end

  -- Fallback to full search from beginning to cursor
  for _, node, _, _ in query:iter_captures(root, 0, 0, cursor_row) do
    if node then
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

M.prev_func_declaration = function()
  local count = vim.v.count
  if count == 0 then
    count = 1
  end
  local root, query = get_root_and_query()
  for _ = 1, count do
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    local current_row = cursor_pos[1] - 1
    local current_col = cursor_pos[2]
    local previous_node = M.find_prev_func_declaration(root, query, current_row, current_col)
    if previous_node then
      local start_row, start_col, _, _ = previous_node:range()
      vim.api.nvim_win_set_cursor(0, { start_row + 1, start_col })
      current_row = start_row
    end
  end
end



return M
