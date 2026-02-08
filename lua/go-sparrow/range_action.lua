local M = {}

local DEFAULT_QUERY_NAME = 'go_nav_func_decl'
local LUA_QUERY_NAME = 'go_nav_range_action'
local HIGHLIGHT_NS = vim.api.nvim_create_namespace 'go_sparrow_range_action'
local util_treesitter = require 'go-sparrow.util_treesitter'

local function get_query_name(lang)
  if lang == 'lua' then
    return LUA_QUERY_NAME
  end
  return DEFAULT_QUERY_NAME
end

local function notify_warn(message)
  vim.schedule(function() vim.notify(message, vim.log.levels.WARN) end)
end

local function node_contains_line(node, line)
  local start_row, _, end_row, _ = node:range()
  return start_row <= line and end_row >= line
end

local function is_function_like_node(lang, node_type)
  if lang == 'lua' then
    return node_type == 'function_declaration'
        or node_type == 'function_definition'
        or node_type == 'assignment_statement'
        or node_type == 'variable_declaration'
  end

  if lang == 'go' then
    return node_type == 'function_declaration'
        or node_type == 'method_declaration'
        or node_type == 'func_literal'
  end

  if lang == 'fish' then
    return node_type == 'function_definition'
  end

  if lang == 'rust' then
    return node_type == 'function_item'
        or node_type == 'function_signature_item'
        or node_type == 'closure_expression'
  end

  if lang == 'zig' then
    return node_type == 'function_declaration'
  end

  return node_type:find('function', 1, true) ~= nil
      or node_type:find('method', 1, true) ~= nil
end

local function resolve_function_node(lang, capture_node, root)
  local node = capture_node
  while node do
    if is_function_like_node(lang, node:type()) then
      return node
    end
    if node == root then
      break
    end
    node = node:parent()
  end
  return nil
end

local function get_current_context()
  local bufnr = vim.api.nvim_get_current_buf()
  local filetype = vim.bo[bufnr].filetype
  local lang = vim.treesitter.language.get_lang(filetype)
  if not lang then
    return nil
  end

  local ok_parser, parser_or_err = pcall(vim.treesitter.get_parser, bufnr, lang)
  if not ok_parser then
    notify_warn(
      ('treesitter: parser unavailable for %s (%s)'):format(
        lang,
        tostring(parser_or_err)
      )
    )
    return nil
  end

  local parser = parser_or_err
  local ok_tree, tree_or_err = pcall(function()
    assert(parser, 'Parser not found for ' .. lang)
    local trees = parser:parse()
    return trees and trees[1]
  end)
  if not ok_tree then
    notify_warn(
      ('treesitter: failed to parse for %s (%s)'):format(
        lang,
        tostring(tree_or_err)
      )
    )
    return nil
  end

  local tree = tree_or_err
  if not tree then
    return nil
  end

  local root = tree:root()
  if not root then
    return nil
  end

  local query_name = get_query_name(lang)
  local ok_query, query_or_err = pcall(function()
    return util_treesitter.get_cached_query_by_name(lang, query_name)
  end)
  if not ok_query then
    notify_warn(
      ('treesitter: query %s unavailable for %s (%s)'):format(
        query_name,
        lang,
        tostring(query_or_err)
      )
    )
    return nil
  end

  return {
    bufnr = bufnr,
    lang = lang,
    root = root,
    query = query_or_err,
  }
end

local function find_enclosing_function(context, line)
  local enclosing_node = nil
  local current_start_row = -1

  for id, node in
  context.query:iter_captures(context.root, context.bufnr, 0, -1)
  do
    local capture_name = context.query.captures[id]
    local candidate = nil

    if capture_name == 'func_node' then
      candidate = node
    elseif capture_name == 'func_decl_start' then
      candidate = resolve_function_node(context.lang, node, context.root)
    end

    if candidate and node_contains_line(candidate, line) then
      local start_row = candidate:range()
      if start_row > current_start_row then
        enclosing_node = candidate
        current_start_row = start_row
      end
    end
  end

  return enclosing_node
end

local function get_nearest_function_context()
  local context = get_current_context()
  if not context then
    return nil
  end

  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local line = cursor_pos[1] - 1
  local node = find_enclosing_function(context, line)
  if not node then
    notify_warn 'No function found (or treesitter not ready)'
    return nil
  end

  context.node = node
  return context
end

local function get_function_name(context)
  for id, node in
  context.query:iter_captures(context.node, context.bufnr, 0, -1)
  do
    if context.query.captures[id] == 'func_decl_start' then
      return vim.treesitter.get_node_text(node, context.bufnr)
    end
  end

  for child in context.node:iter_children() do
    local child_type = child:type()
    if
        child_type == 'identifier'
        or child_type == 'name'
        or child_type == 'field_identifier'
    then
      return vim.treesitter.get_node_text(child, context.bufnr)
    end
  end

  return nil
end

M.yank_function = function()
  local context = get_nearest_function_context()
  if not context then
    return
  end

  local func_text = vim.treesitter.get_node_text(context.node, context.bufnr)
  vim.fn.setreg('*', func_text)

  local start_row, start_col, end_row, end_col = context.node:range()
  vim.highlight.range(
    context.bufnr,
    HIGHLIGHT_NS,
    'IncSearch',
    { start_row, start_col },
    { end_row, end_col }
  )

  vim.defer_fn(
    function()
      vim.api.nvim_buf_clear_namespace(context.bufnr, HIGHLIGHT_NS, 0, -1)
    end,
    100
  )

  local func_name = get_function_name(context)
  if func_name and func_name ~= '' then
    vim.notify('Yanked function: ' .. func_name)
  else
    vim.notify 'Yanked function'
  end
end

M.visual_function = function()
  local context = get_nearest_function_context()
  if not context then
    return
  end

  local start_row, start_col, end_row, end_col = context.node:range()
  vim.cmd 'normal! v'
  vim.api.nvim_win_set_cursor(0, { start_row + 1, start_col })
  vim.cmd 'normal! o'
  vim.api.nvim_win_set_cursor(0, { end_row + 1, end_col })
  vim.cmd 'normal! o'
end

M.delete_function = function()
  M.visual_function()
  vim.cmd 'normal! d'
end


return M
