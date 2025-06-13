local M = {}

local cache = {
  buf_nr = nil,
  changedtick = nil,
  matches = nil,
}

local query_string = [[
;; Target identifiers in short variable declarations
(short_var_declaration
  left: (expression_list
    (identifier) @identifier)
  right: (expression_list
    (call_expression)))
]]

local function get_parser_and_query()
  local buf_nr = vim.api.nvim_get_current_buf()
  local lang = vim.treesitter.language.get_lang(vim.bo.filetype)
  assert(lang, 'Language is nil')
  local parser = vim.treesitter.get_parser(buf_nr, lang)
  assert(parser, 'Parser is nil')
  local tree = parser:parse()[1]
  local root = tree:root()

  local query = vim.treesitter.query.parse(lang, query_string)
  return parser, query, root, buf_nr
end

local function get_cached_matches()
  local buf_nr = vim.api.nvim_get_current_buf()
  local changedtick = vim.api.nvim_buf_get_changedtick(buf_nr)

  if cache.buf_nr == buf_nr and cache.changedtick == changedtick and cache.matches then
    return cache.matches
  end

  local _, query, root = get_parser_and_query()
  local matches = {}
  local top_line, bottom_line = require('go-sparrow.util_range').get_visible_range()

  -- First get matches in visible range
  for id, node, _ in query:iter_captures(root, buf_nr, top_line, bottom_line) do
    local capture_name = query.captures[id]
    if capture_name == 'identifier' then
      local start_row, start_col = node:range()
      table.insert(matches, {
        node = node,
        row = start_row,
        col = start_col,
      })
    end
  end

  -- If we need more matches, expand search
  if #matches < 10 then -- arbitrary threshold
    for id, node, _ in query:iter_captures(root, buf_nr, 0, -1) do
      local capture_name = query.captures[id]
      if capture_name == 'identifier' then
        local start_row, start_col = node:range()
        -- Skip if already in visible range
        if start_row < top_line or start_row > bottom_line then
          table.insert(matches, {
            node = node,
            row = start_row,
            col = start_col,
          })
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

local function find_prev_identifier(row, col)
  local matches = get_cached_matches()
  assert(matches, 'No matches found')
  local previous_match = nil

  for _, match in ipairs(matches) do
    if match.row < row or (match.row == row and match.col < col) then
      previous_match = match
    else
      break
    end
  end

  return previous_match and previous_match.node or nil
end

local function find_next_identifier(row, col)
  local matches = get_cached_matches()
  assert(matches, 'No matches found')

  for _, match in ipairs(matches) do
    if match.row > row or (match.row == row and match.col > col) then
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
    local current_row, current_col = cursor_pos[1] - 1, cursor_pos[2]
    local next_node = find_next_identifier(current_row, current_col)

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
    local current_row, current_col = cursor_pos[1] - 1, cursor_pos[2]
    local previous_node = find_prev_identifier(current_row, current_col)

    if previous_node then
      local start_row, start_col, _, _ = previous_node:range()
      vim.api.nvim_win_set_cursor(0, { start_row + 1, start_col })
    end
  end
end

M.next_identifier = move_to_next_identifier
M.prev_identifier = move_to_previous_identifier

return M

