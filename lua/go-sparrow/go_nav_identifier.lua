local M = {}

local cache = {
  buf_nr = nil,
  changedtick = nil,
  matches = nil,
}

-- Query strings as constants per language
local QUERY_STRINGS = {
  go = [[
    (short_var_declaration
      left: (expression_list
        (identifier) @identifier)
      right: (expression_list
        (call_expression)))
        ]],
  lua = [[
      (variable_declaration
        (assignment_statement
           (variable_list
           	  name: (identifier)) @identifier
	)
      )
    ]],
  rust = [[
      (let_declaration
        pattern: (identifier) @identifier
        value: (call_expression))

      (let_declaration
        pattern: (mut_pattern (identifier) @identifier)
        value: (call_expression))
    ]],
}

local function get_query_string()
  local lang = vim.treesitter.language.get_lang(vim.bo.filetype)
  if not lang then
    return nil
  end
  return QUERY_STRINGS[lang]
end

local function get_cached_matches()
  local buf_nr = vim.api.nvim_get_current_buf()
  local changedtick = vim.api.nvim_buf_get_changedtick(buf_nr)

  if
    cache.buf_nr == buf_nr
    and cache.changedtick == changedtick
    and cache.matches
  then
    return cache.matches
  end

  local query_string = get_query_string()
  if not query_string then
    return {}
  end
  local _, query, root =
    require('go-sparrow.util_treesitter').get_parser_and_query(query_string)
  local matches = {}
  local top_line, bottom_line =
    require('go-sparrow.util_treesitter').get_visible_range()

  local function process_capture(node, start_line, end_line)
    local identifier_text = vim.treesitter.get_node_text(node, buf_nr)
    if identifier_text ~= 'err' then
      local start_row, start_col = node:range()
      if
        not start_line
        or not end_line
        or (start_row >= start_line and start_row <= end_line)
      then
        table.insert(matches, {
          node = node,
          row = start_row,
          col = start_col,
        })
      end
    end
  end

  -- First get matches in visible range
  for id, node, _ in query:iter_captures(root, buf_nr, top_line, bottom_line) do
    local capture_name = query.captures[id]
    if capture_name == 'identifier' then
      process_capture(node, top_line, bottom_line)
    end
  end

  -- If we need more matches, expand search
  if #matches < 10 then -- arbitrary threshold
    for id, node, _ in query:iter_captures(root, buf_nr, 0, -1) do
      local capture_name = query.captures[id]
      if capture_name == 'identifier' then
        local start_row, _ = node:range()
        -- Skip if already in visible range
        if start_row < top_line or start_row > bottom_line then
          process_capture(node)
        end
      end
    end
  end

  table.sort(matches, function(a, b)
    if a.row == b.row then
      return a.col < b.col
    end
    return a.row < b.row
  end)

  cache.buf_nr = buf_nr
  cache.changedtick = changedtick
  cache.matches = matches

  return matches
end

local function find_prev_identifier(row)
  local matches = get_cached_matches()
  assert(matches, 'No matches found')
  local previous_match = nil

  for _, match in ipairs(matches) do
    -- Skip identifiers on the same line
    if match.row < row then
      previous_match = match
    elseif match.row >= row then
      break
    end
  end

  return previous_match and previous_match.node or nil
end

local function find_next_identifier(row)
  local matches = get_cached_matches()
  assert(matches, 'No matches found')

  for _, match in ipairs(matches) do
    -- Skip identifiers on the same line
    if match.row > row then
      return match.node
    end
  end

  return nil
end

local function move_to_next_identifier()
  local count = vim.v.count
  if count == 0 then
    count = 1
  end
  for _ = 1, count do
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    local current_row = cursor_pos[1] - 1
    local next_node = find_next_identifier(current_row)

    if next_node then
      local start_row, start_col, _, _ = next_node:range()
      vim.api.nvim_win_set_cursor(0, { start_row + 1, start_col })
    end
  end
end

local function move_to_previous_identifier()
  local count = vim.v.count
  if count == 0 then
    count = 1
  end
  for _ = 1, count do
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    local current_row = cursor_pos[1] - 1
    local previous_node = find_prev_identifier(current_row)

    if previous_node then
      local start_row, start_col, _, _ = previous_node:range()
      vim.api.nvim_win_set_cursor(0, { start_row + 1, start_col })
    end
  end
end

M.next_identifier = move_to_next_identifier
M.prev_identifier = move_to_previous_identifier

return M
