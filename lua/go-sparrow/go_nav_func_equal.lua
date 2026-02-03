local M = {}

local cache = {}

local QUERY_NAMES = {
  go = {
    func_calls = 'func_calls',
    expressions = 'expressions',
  },
  lua = {
    func_calls = 'func_calls',
    expressions = 'expressions',
  },
}

local function get_query_names()
  local lang = vim.treesitter.language.get_lang(vim.bo.filetype)
  return lang and QUERY_NAMES[lang] or nil
end

local function ensure_cache_initialized()
  local queries = get_query_names()
  if queries then
    for query_type, _ in pairs(queries) do
      if not cache[query_type] then
        cache[query_type] = {
          buf_nr = nil,
          changedtick = nil,
          matches = nil,
        }
      end
    end
  end
end

local ignore_list = {
  -- === in test ===
  NoError = true,
  Error = true,
  Errorf = true,

  -- === in log ===
  Info = true,
  Infof = true,
  Warn = true,
  Debug = true,
  Fatal = true,
  Fatalf = true,
  WithFields = true,
  WithField = true,

  -- === in error handling ===
  Wrap = true,
  Wrapf = true,
  New = true,

  -- === go builtins ===
  len = true,
  make = true,
}

local function get_cached_matches(query_type)
  ensure_cache_initialized()

  local buf_nr = vim.api.nvim_get_current_buf()
  local changedtick = vim.api.nvim_buf_get_changedtick(buf_nr)
  local query_cache = cache[query_type]

  if not query_cache then
    return {}
  end

  -- Return cached results if valid
  if query_cache.buf_nr == buf_nr and query_cache.changedtick == changedtick and query_cache.matches then
    return query_cache.matches
  end

  -- Get new matches using cached query
  local queries = get_query_names()
  if not queries then
    return {}
  end
  local query_name = queries[query_type]
  local _, query, root = require('go-sparrow.util_treesitter').get_parser_and_named_query(query_name)
  local matches = {}
  local top_line, bottom_line = require('go-sparrow.util_treesitter').get_visible_range()

  -- Helper function to collect matches from a range
  local function collect_matches(start_line, end_line, skip_visible)
    for id, node, _ in query:iter_captures(root, buf_nr, start_line, end_line) do
      local capture_name = query.captures[id]
      if capture_name == 'func_name' then
        local start_row, start_col = node:range()

        -- Skip if in visible range when expanding search
        if skip_visible and start_row >= top_line and start_row <= bottom_line then
          goto continue
        end

        local func_name = vim.treesitter.get_node_text(node, buf_nr)
        if not ignore_list[func_name] then
          table.insert(matches, {
            node = node,
            row = start_row,
            col = start_col,
            name = func_name,
          })
        end
        ::continue::
      end
    end
  end

  -- First collect matches in visible range
  collect_matches(top_line, bottom_line, false)

  -- If we need more matches, expand search to entire buffer
  if #matches < 10 then -- arbitrary threshold
    collect_matches(0, -1, true)
  end

  -- Sort matches by position
  table.sort(matches, function(a, b)
    if a.row == b.row then
      return a.col < b.col
    end
    return a.row < b.row
  end)

  -- Update cache
  query_cache.buf_nr = buf_nr
  query_cache.changedtick = changedtick
  query_cache.matches = matches

  return matches
end

local function find_prev_match(query_type, row, col)
  local matches = get_cached_matches(query_type)
  assert(matches, string.format('No %s matches found', query_type))

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

local function find_next_match(query_type, row, col)
  local matches = get_cached_matches(query_type)
  assert(matches, string.format('No %s matches found', query_type))

  for _, match in ipairs(matches) do
    if match.row > row or (match.row == row and match.col > col) then
      return match.node
    end
  end

  return nil
end

local function move_to_match(query_type, direction)
  local count = vim.v.count
  if count == 0 then
    count = 1
  end

  for _ = 1, count do
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    local current_row, current_col = cursor_pos[1] - 1, cursor_pos[2]

    local node
    if direction == 'next' then
      node = find_next_match(query_type, current_row, current_col)
    else
      node = find_prev_match(query_type, current_row, current_col)
    end

    if node then
      local start_row, start_col, _, _ = node:range()
      vim.api.nvim_win_set_cursor(0, { start_row + 1, start_col })
    end
  end
end

local function get_prev_match_text(query_type)
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local current_row, current_col = cursor_pos[1] - 1, cursor_pos[2]
  local previous_node = find_prev_match(query_type, current_row, current_col)

  if previous_node then
    return vim.treesitter.get_node_text(previous_node, 0)
  end
end

function M.get_prev_func_call_with_equal() return get_prev_match_text 'func_calls' end

M.next_function_call = function() move_to_match('func_calls', 'next') end
M.prev_function_call = function() move_to_match('func_calls', 'prev') end
M.next_expression = function() move_to_match('expressions', 'next') end
M.prev_expression = function() move_to_match('expressions', 'prev') end

return M
