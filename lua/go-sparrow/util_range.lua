local M = {}

function M.get_visible_range()
  local win = vim.api.nvim_get_current_win()
  local top_line = vim.fn.line('w0', win) - 1 -- 0-indexed
  local bottom_line = vim.fn.line('w$', win) - 1 -- 0-indexed
  return top_line, bottom_line
end

function M.get_parser_and_query(query_string)
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

function M.get_root_node()
  local buf_nr = vim.api.nvim_get_current_buf()
  local lang = vim.treesitter.language.get_lang(vim.bo.filetype)
  local parser = vim.treesitter.get_parser(buf_nr, lang)
  assert(parser, 'No parser found for this buffer')
  local tree = parser:parse()[1]
  local root = tree:root()
  return root
end

return M
