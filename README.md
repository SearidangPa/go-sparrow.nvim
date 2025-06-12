# go-sparrow

<div align="center">
  <img src="go-sparrow.png" alt="go-sparrow" width="200">
</div>

A Neovim plugin that provides enhanced navigation for Go and Lua files using treesitter. Fly inside the code tree fast like a sparrow!

While plugin that uses label-based navigation such as flash.nvim is great, sometimes i get tired of the label. I don't want to see and react to the label.

## Features

- **Function Declaration Navigation** - Jump between function and method declarations
- **Expression Statement Navigation** - Navigate function calls in expression statements  
- **Function Call with Assignment Navigation** - Move between function calls with variable assignments
- **Smart Filtering** - Ignore common logging functions during navigation
- **Count Support** - Use count prefixes to jump multiple items at once
- **Caching System** - Optimized performance for repeated navigation
- **Unified Repeat Motion** - Repeat last navigation command across all navigation types (coming soon)

## Installation

### lazy.nvim

```lua
{
  'SearidangPa/go-sparrow',
  ft = { 'go', 'lua' },
  lazy = true,
  config = function()
    local sparrow = require('go-sparrow')
    
    -- Manual keymap setup required (setup function is currently empty)
    vim.keymap.set('n', ']m', sparrow.next_function_declaration, { desc = 'Next function declaration' })
    vim.keymap.set('n', '[m', sparrow.prev_function_declaration, { desc = 'Previous function declaration' })
    vim.keymap.set('n', ']e', sparrow.next_expression_statement, { desc = 'Next expression statement' })
    vim.keymap.set('n', '[e', sparrow.prev_expression_statement, { desc = 'Previous expression statement' })
    vim.keymap.set('n', ']f', sparrow.next_function_call, { desc = 'Next function call' })
    vim.keymap.set('n', '[f', sparrow.prev_function_call, { desc = 'Previous function call' })
  end,
}
```

### Alternative Keybinding Setup

```lua
{
  'SearidangPa/go-sparrow',
  ft = { 'go', 'lua' },
  config = function()
    local sparrow = require('go-sparrow')
    
    -- Set up custom keybindings with leader key
    vim.keymap.set('n', '<leader>fn', sparrow.next_function_declaration, { desc = 'Next function' })
    vim.keymap.set('n', '<leader>fp', sparrow.prev_function_declaration, { desc = 'Previous function' })
    vim.keymap.set('n', '<leader>en', sparrow.next_expression_statement, { desc = 'Next expression' })
    vim.keymap.set('n', '<leader>ep', sparrow.prev_expression_statement, { desc = 'Previous expression' })
    vim.keymap.set('n', '<leader>cn', sparrow.next_function_call, { desc = 'Next function call' })
    vim.keymap.set('n', '<leader>cp', sparrow.prev_function_call, { desc = 'Previous function call' })
  end,
}
```

## Recommended Keybindings

| Key | Action |
|-----|--------|
| `]m` | Next function declaration |
| `[m` | Previous function declaration |
| `]e` | Next expression statement |
| `[e` | Previous expression statement |
| `]f` | Next function call with assignment |
| `[f` | Previous function call with assignment |

**Note**: Manual keybinding setup is required as the plugin doesn't configure keymaps automatically.

## Usage

All navigation commands support count prefixes:
- `3]m` - Jump to the 3rd next function declaration
- `2[e` - Jump to the 2nd previous expression statement

**Repeat Motion Feature**: Currently in development. The plugin includes references to a unified repeat motion system that will allow repeating the last navigation command across all navigation types.

## API

```lua
local sparrow = require('go-sparrow')

sparrow.next_function_declaration()
sparrow.prev_function_declaration()
sparrow.next_expression_statement()
sparrow.prev_expression_statement()
sparrow.next_function_call()
sparrow.prev_function_call()
-- sparrow.repeat_last_motion() -- Coming soon
```

## Requirements

- Neovim 0.8+ with treesitter support
- Go and Lua treesitter parsers installed

## License

MIT
