local function find_next_if_bracket(node, row, col)
  local top_line, bottom_line = require('go-sparrow.util_treesitter').get_visible_range()

  local function search_in_range(n, start_row, end_row)
    for child in n:iter_children() do
      local child_start, _, child_end, _ = child:range()

      -- Skip nodes completely outside our range
      if child_end < start_row or child_start > end_row then
        goto continue
      end

      local candidate = nil

      if child:type() == 'if_statement' then
        -- Check if the condition contains "err" as left identifier
        local should_skip = false
        for if_child in child:iter_children() do
          if if_child:type() == 'binary_expression' then
            local left_child = if_child:child(0)
            if left_child and left_child:type() == 'identifier' then
              local left_text = vim.treesitter.get_node_text(left_child, 0)
              if left_text == 'err' then
                should_skip = true
                break
              end
            end
          end
        end

        if not should_skip then
          -- Find the bracket block within the if statement
          for if_child in child:iter_children() do
            if if_child:type() == 'block' then
              candidate = if_child
              break
            end
          end
        end
      end

      if candidate then
        local s_row, s_col, _, _ = candidate:range()
        if s_row > row or (s_row == row and s_col > col) then
          return candidate
        end
      end

      local descendant = search_in_range(child, start_row, end_row)
      if descendant then
        return descendant
      end

      ::continue::
    end
    return nil
  end

  -- First search in visible range
  local result = search_in_range(node, top_line, bottom_line)
  if result then
    return result
  end

  -- Fallback to full search from cursor to end
  return search_in_range(node, row, math.huge)
end

local function find_previous_if_bracket(node, row, col)
  local top_line, bottom_line = require('go-sparrow.util_treesitter').get_visible_range()
  local previous_node = nil

  local function search_in_range(n, start_row, end_row)
    for child in n:iter_children() do
      local child_start, _, child_end, _ = child:range()

      -- Skip nodes completely outside our range
      if child_end < start_row or child_start > end_row then
        goto continue
      end

      search_in_range(child, start_row, end_row)

      local candidate = nil

      if child:type() == 'if_statement' then
        -- Check if the condition contains "err" as left identifier
        local should_skip = false
        for if_child in child:iter_children() do
          if if_child:type() == 'binary_expression' then
            local left_child = if_child:child(0)
            if left_child and left_child:type() == 'identifier' then
              local left_text = vim.treesitter.get_node_text(left_child, 0)
              if left_text == 'err' then
                should_skip = true
                break
              end
            end
          end
        end

        if not should_skip then
          -- Find the bracket block within the if statement
          for if_child in child:iter_children() do
            if if_child:type() == 'block' then
              candidate = if_child
              break
            end
          end
        end
      end

      if candidate then
        local s_row, s_col, _, _ = candidate:range()
        if s_row < row or (s_row == row and s_col < col) then
          if not previous_node then
            previous_node = candidate
          else
            local prev_row, prev_col, _, _ = previous_node:range()
            if s_row > prev_row or (s_row == prev_row and s_col > prev_col) then
              previous_node = candidate
            end
          end
        end
      end

      ::continue::
    end
  end

  -- First search in visible range
  search_in_range(node, top_line, bottom_line)

  if previous_node then
    return previous_node
  end

  -- Fallback to full search from beginning to cursor
  search_in_range(node, 0, row)
  return previous_node
end

local function move_to_next_if_bracket()
  local count = vim.v.count
  if count == 0 then
    count = 1
  end
  local root = require('go-sparrow.util_treesitter').get_root_node()
  for _ = 1, count do
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    local current_row, current_col = cursor_pos[1] - 1, cursor_pos[2]
    local next_node = find_next_if_bracket(root, current_row, current_col)

    if next_node then
      local start_row, start_col, _, _ = next_node:range()
      vim.api.nvim_win_set_cursor(0, { start_row + 1, start_col })
    end
  end
end

local function move_to_previous_if_bracket()
  local count = vim.v.count
  if count == 0 then
    count = 1
  end
  local root = require('go-sparrow.util_treesitter').get_root_node()
  for _ = 1, count do
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    local current_row, current_col = cursor_pos[1] - 1, cursor_pos[2]
    local previous_node = find_previous_if_bracket(root, current_row, current_col)

    if previous_node then
      local start_row, start_col, _, _ = previous_node:range()
      vim.api.nvim_win_set_cursor(0, { start_row + 1, start_col })
    end
  end
end

local M = {}

M.next_if_bracket = move_to_next_if_bracket
M.prev_if_bracket = move_to_previous_if_bracket

return M
