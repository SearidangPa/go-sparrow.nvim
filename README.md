# sparrow

<div align="center">
  <img src="sparrow.png" alt="sparrow" width="200">
</div>

A Neovim plugin that provides Tree-sitter-powered navigation across multiple languages. Fly inside the code tree fast like a sparrow.

Label-based navigation plugins like flash.nvim are great, but sometimes you just want direct structural jumps without labels.

## Features

- **Function Declaration Navigation** - Jump between function and method declarations
- **Expression Navigation** - Navigate function calls in expression statements
- **Function Call with Assignment Navigation** - Move between function calls with variable assignments
- **Identifier Navigation** - Move across assignment identifiers while skipping noisy names
- **Range Actions** - Yank, visually select, or delete the enclosing function
- **Count Support** - Use count prefixes to jump multiple items at once
- **Caching System** - Optimized performance for repeated navigation

## Language Support

- **Function declarations**: Go, Lua, Rust, Zig, Fish
- **Expressions / function calls / identifiers**: Go, Lua, Rust
- **Range actions**: Go, Lua, Rust, Zig, Fish

## Installation

### lazy.nvim

```lua
{
  'SearidangPa/sparrow',
  ft = { 'go', 'lua', 'rust', 'zig', 'fish' },
  lazy = true,
  config = function()
    local sparrow = require('sparrow')

    vim.keymap.set('n', ']m', sparrow.next_function_declaration, { desc = 'Next function declaration' })
    vim.keymap.set('n', '[m', sparrow.prev_function_declaration, { desc = 'Previous function declaration' })
    vim.keymap.set('n', ']e', sparrow.next_expression, { desc = 'Next expression' })
    vim.keymap.set('n', '[e', sparrow.prev_expression, { desc = 'Previous expression' })
    vim.keymap.set('n', ']f', sparrow.next_function_call, { desc = 'Next function call' })
    vim.keymap.set('n', '[f', sparrow.prev_function_call, { desc = 'Previous function call' })
    vim.keymap.set('n', ']i', sparrow.next_identifier, { desc = 'Next identifier' })
    vim.keymap.set('n', '[i', sparrow.prev_identifier, { desc = 'Previous identifier' })
  end,
}
```

### Alternative Keybinding Setup

```lua
{
  'SearidangPa/sparrow',
  ft = { 'go', 'lua', 'rust', 'zig', 'fish' },
  config = function()
    local sparrow = require('sparrow')

    vim.keymap.set('n', '<leader>fn', sparrow.next_function_declaration, { desc = 'Next function' })
    vim.keymap.set('n', '<leader>fp', sparrow.prev_function_declaration, { desc = 'Previous function' })
    vim.keymap.set('n', '<leader>en', sparrow.next_expression, { desc = 'Next expression' })
    vim.keymap.set('n', '<leader>ep', sparrow.prev_expression, { desc = 'Previous expression' })
    vim.keymap.set('n', '<leader>cn', sparrow.next_function_call, { desc = 'Next function call' })
    vim.keymap.set('n', '<leader>cp', sparrow.prev_function_call, { desc = 'Previous function call' })
    vim.keymap.set('n', '<leader>in', sparrow.next_identifier, { desc = 'Next identifier' })
    vim.keymap.set('n', '<leader>ip', sparrow.prev_identifier, { desc = 'Previous identifier' })
  end,
}
```

## Recommended Keybindings

| Key | Action |
|-----|--------|
| `]m` | Next function declaration |
| `[m` | Previous function declaration |
| `]e` | Next expression |
| `[e` | Previous expression |
| `]f` | Next function call with assignment |
| `[f` | Previous function call with assignment |
| `]i` | Next identifier |
| `[i` | Previous identifier |

## Usage

All navigation commands support count prefixes:
- `3]m` - Jump to the 3rd next function declaration
- `2[e` - Jump to the 2nd previous expression

## API

```lua
local sparrow = require('sparrow')

sparrow.next_function_declaration()
sparrow.prev_function_declaration()
sparrow.next_expression()
sparrow.prev_expression()
sparrow.next_function_call()
sparrow.prev_function_call()
sparrow.next_identifier()
sparrow.prev_identifier()
```

## Requirements

- Neovim 0.8+ with Tree-sitter support
- Tree-sitter parsers installed for the languages you use

## License

MIT
