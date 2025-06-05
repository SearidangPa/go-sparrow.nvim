# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

go-sparrow is a Neovim plugin that provides enhanced navigation for Go and Lua files using treesitter. The plugin enables fast movement between function declarations and expressions, like a sparrow flying through code trees.

## Architecture

The plugin consists of three main navigation modules:

- `lua/go_nav_func_decl.lua` - Navigation between function declarations using `]m`/`[m` keybindings
- `lua/go_nav_func_expr.lua` - Navigation between expression statements using `]e`/`[e` keybindings  
- `lua/go_nav_func_equal.lua` - Navigation between function calls with assignment/declaration using `]f`/`[f` keybindings

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
- Supports repeat motion with `\` key
- Keybindings: `]f` (next), `[f` (previous), `\` (repeat last motion)

## Key Features

- Treesitter-based parsing for accurate code structure detection
- Support for both Go and Lua languages
- Ignore lists to skip common utility functions during navigation
- Count prefix support for all navigation commands
- Caching system for performance optimization
- Repeat motion functionality