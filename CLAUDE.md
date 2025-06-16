# CLAUDE.md

go-sparrow is a Neovim plugin for treesitter-based Go/Lua navigation.

## Navigation Modules

- `go_nav_func_decl.lua` - Function declarations (`]m`/`[m`)
- `go_nav_func_expr.lua` - Expression statements (`]e`/`[e`) with logging ignore list
- `go_nav_func_equal.lua` - Function calls in assignments (`]f`/`[f`) with Join ignore list, caching
- `go_nav_identifier.lua` - Identifiers in declarations (`]i`/`[i`) excluding "err", caching
- `go_nav_if.lua` - If statement consequence blocks (`]c`/`[c`)
- `util_range.lua` - Visible buffer range utilities
- `init.lua` - Main interface (empty setup function)

## Key Features

- Count prefix support
- Visible range optimization with fallback
- Caching for performance
- Manual keymap setup required