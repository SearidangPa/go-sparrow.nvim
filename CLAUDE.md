# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

go-sparrow is a Neovim plugin that provides enhanced navigation for Go and Lua files using treesitter. The plugin enables fast movement between function declarations and expressions, like a sparrow flying through code trees.

## Architecture

The plugin consists of five main navigation modules plus shared utility modules:

- `lua/go-sparrow/go_nav_func_decl.lua` - Navigation between function declarations using `]m`/`[m` keybindings
- `lua/go-sparrow/go_nav_func_expr.lua` - Navigation between expression statements using `]e`/`[e` keybindings  
- `lua/go-sparrow/go_nav_func_equal.lua` - Navigation between function calls with assignment/declaration using `]f`/`[f` keybindings
- `lua/go-sparrow/go_nav_identifier.lua` - Navigation between identifiers in short variable declarations using `]i`/`[i` keybindings
- `lua/go-sparrow/util_range.lua` - Utility functions for determining visible buffer ranges
- `lua/go-sparrow/init.lua` - Main module initialization and setup function

Each module uses treesitter queries to parse and navigate code structures:

### Function Declaration Navigation
- Supports both Go (`function_declaration`, `method_declaration`) and Lua (`function_declaration`) 
- Uses count prefix for jumping multiple functions at once
- Keybindings: `]m` (next), `[m` (previous)

### Expression Statement Navigation  
- Targets function calls in expression statements and go statements
- Includes ignore list for common logging functions (Error, Info, Debug, etc.)
- Filters to only call expressions that are standalone statements
- Keybindings: `]e` (next), `[e` (previous)

### Function Calls with Assignment Navigation
- Specifically targets function calls in short variable declarations (`result, err := func()`) and assignment statements
- Uses caching system to optimize repeated navigation in same buffer
- Includes ignore list for specific functions (Join)
- Integrated with unified repeat motion system
- Keybindings: `]f` (next), `[f` (previous)

### Identifier Navigation
- Targets identifiers in short variable declarations (`exists, err := osutil.Exists(pathBuilder)`)
- Skips identifiers on the same line to avoid iterating through same-line variables
- Uses caching system for performance optimization
- Integrated with unified repeat motion system
- Keybindings: `]i` (next), `[i` (previous)

### Unified Repeat Motion System  
- Navigation modules reference a shared state module (`repeat_motion.lua`) for repeat functionality
- Each navigation function calls `require('go-sparrow.repeat_motion').set_last_function()` to track the last executed function
- **Note**: The repeat_motion.lua module is currently missing from the codebase but is referenced by all navigation modules
- Expected API functions: `set_last_function()`, `get_last_function()`, `clear_last_function()`, `has_last_function()`, `repeat_last_function()`
- Expected keybinding: `\` (repeat last motion)

### Utility Modules
- `util_range.lua` provides `get_visible_range()` function to determine the currently visible lines in the window
- Used by navigation modules to optimize performance by prioritizing searches within the visible buffer area
- Falls back to full buffer search when needed

### Plugin Setup
- `init.lua` provides the main plugin interface and setup function
- Exports all navigation functions for external access
- **Note**: The `setup()` function is currently empty and does not configure any keybindings
- Users must manually set up keybindings to use the navigation functions

## Key Features

- Treesitter-based parsing for accurate code structure detection
- Support for both Go and Lua languages
- Ignore lists to skip common utility functions during navigation
- Count prefix support for all navigation commands (e.g., `3]m` to jump to the 3rd next function)
- Caching system for performance optimization in function call navigation
- Planned unified repeat motion functionality (repeat_motion.lua module needed)
- Performance optimization via visible range prioritization
- Modular architecture with separate concerns for each navigation type

## Installation and Setup

**Note**: The setup function is currently empty. Users must manually configure keybindings.

```lua
-- Manual keymap setup required
local go_sparrow = require('go-sparrow')

-- Function declaration navigation
vim.keymap.set('n', ']m', go_sparrow.next_function_declaration, { desc = 'Next function declaration' })
vim.keymap.set('n', '[m', go_sparrow.prev_function_declaration, { desc = 'Previous function declaration' })

-- Expression statement navigation
vim.keymap.set('n', ']e', go_sparrow.next_expression_statement, { desc = 'Next expression statement' })
vim.keymap.set('n', '[e', go_sparrow.prev_expression_statement, { desc = 'Previous expression statement' })

-- Function call navigation
vim.keymap.set('n', ']f', go_sparrow.next_function_call, { desc = 'Next function call' })
vim.keymap.set('n', '[f', go_sparrow.prev_function_call, { desc = 'Previous function call' })

-- Identifier navigation
vim.keymap.set('n', ']i', go_sparrow.next_identifier, { desc = 'Next identifier' })
vim.keymap.set('n', '[i', go_sparrow.prev_identifier, { desc = 'Previous identifier' })

-- Repeat motion (requires repeat_motion.lua module)
-- vim.keymap.set('n', '\\', function() 
--   require('go-sparrow.repeat_motion').repeat_last_function() 
-- end, { desc = 'Repeat last motion' })
```
