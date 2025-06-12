# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

go-sparrow is a Neovim plugin that provides enhanced navigation for Go and Lua files using treesitter. The plugin enables fast movement between function declarations and expressions, like a sparrow flying through code trees.

## Architecture

The plugin consists of four main navigation modules plus shared utility modules:

- `lua/go-sparrow/go_nav_func_decl.lua` - Navigation between function declarations using `]m`/`[m` keybindings
- `lua/go-sparrow/go_nav_func_expr.lua` - Navigation between expression statements using `]e`/`[e` keybindings  
- `lua/go-sparrow/go_nav_func_equal.lua` - Navigation between function calls with assignment/declaration using `]f`/`[f` keybindings
- `lua/go-sparrow/repeat_motion.lua` - Shared state management for unified repeat motion functionality
- `lua/go-sparrow/util_range.lua` - Utility functions for determining visible buffer ranges
- `lua/go-sparrow/init.lua` - Main module initialization and setup function

Each module uses treesitter queries to parse and navigate code structures:

### Function Declaration Navigation
- Supports both Go (`function_declaration`, `method_declaration`) and Lua (`function_declaration`) 
- Uses count prefix for jumping multiple functions at once
- Integrated with unified repeat motion system
- Keybindings: `]m` (next), `[m` (previous)

### Expression Statement Navigation  
- Targets function calls in expression statements and go statements
- Includes ignore list for common logging functions (Error, Info, Debug, etc.)
- Filters to only call expressions that are standalone statements
- Integrated with unified repeat motion system
- Keybindings: `]e` (next), `[e` (previous)

### Function Calls with Assignment Navigation
- Specifically targets function calls in short variable declarations (`result, err := func()`) and assignment statements
- Uses caching system to optimize repeated navigation in same buffer
- Includes ignore list for specific functions (Join)
- Integrated with unified repeat motion system
- Keybindings: `]f` (next), `[f` (previous)

### Unified Repeat Motion System  
- Shared state module (`repeat_motion.lua`) tracks last function call for repeat functionality
- Stores reference to the last navigation function that was executed
- Single `\` keymap works regardless of which navigation type was used last
- API functions: `set_last_function()`, `get_last_function()`, `clear_last_function()`, `has_last_function()`, `repeat_last_function()`
- Keybinding: `\` (repeat last motion)

All navigation modules now use the function-reference-based repeat system via `set_last_function()`.

### Utility Modules
- `util_range.lua` provides `get_visible_range()` function to determine the currently visible lines in the window
- Used by navigation modules to optimize performance by prioritizing searches within the visible buffer area
- Falls back to full buffer search when needed

### Plugin Setup
- `init.lua` provides the main plugin interface and setup function
- Exports all navigation functions for external access
- `setup()` function configures keybindings with customizable options
- Default keybindings can be disabled by passing `keymaps = false` to setup
- Individual keybindings can be customized via setup options

## Key Features

- Treesitter-based parsing for accurate code structure detection
- Support for both Go and Lua languages
- Ignore lists to skip common utility functions during navigation
- Count prefix support for all navigation commands (e.g., `3]m` to jump to the 3rd next function)
- Caching system for performance optimization in function call navigation
- Unified repeat motion functionality across all navigation types
- Performance optimization via visible range prioritization
- Configurable keybindings through setup function
- Modular architecture with separate concerns for each navigation type

## Installation and Setup

```lua
-- Basic setup with default keybindings
require('go-sparrow').setup()

-- Custom keybindings
require('go-sparrow').setup({
  next_function_declaration = ']m',
  prev_function_declaration = '[m',
  next_expression_statement = ']e', 
  prev_expression_statement = '[e',
  next_function_call = ']f',
  prev_function_call = '[f',
  repeat_last_motion = '\\'
})

-- Disable default keybindings
require('go-sparrow').setup({ keymaps = false })
```