# AGENTS.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Common commands

### Formatting (Lua)
- Format:
  - `make lua_fmt`
  - or `stylua lua/ --config-path=.stylua.toml`
- Check formatting (CI-style):
  - `make lua_fmt_check`
  - or `stylua lua/ --config-path=.stylua.toml --check`

### Lint (Lua)
- Lint:
  - `make lua_lint`
  - or `luacheck lua/ --globals vim`

### One-shot local check
- `make check` (runs `lua_lint` + `lua_fmt_check`)

### Tests
- No automated test suite is present in this repository.

## High-level architecture

This is a Neovim plugin written in Lua that uses Tree-sitter queries to implement “jump” motions (and a few range actions) across multiple languages.

### Entry point / public API
- `lua/go-sparrow/init.lua` exposes the public API that users bind to keymaps (via `require('go-sparrow')`).
- There is no `setup()` today; consumers set keymaps manually.
- It is intentionally thin: each exported function delegates to a specific module (navigation type).

### Tree-sitter integration
- `lua/go-sparrow/util_treesitter.lua` is the shared Tree-sitter utility layer:
  - Resolves current buffer + Tree-sitter language from `vim.bo.filetype`.
  - Gets parser/root node.
  - Computes visible window line range (`w0`/`w$`) used for “search visible first” optimizations.
  - Caches compiled queries so repeated motions are fast.

### Query files (the “data layer”)
- Tree-sitter queries live in `queries/<lang>/`.
- Modules that call `vim.treesitter.query.get(lang, query_name)` rely on these files being on Neovim’s runtimepath (they are provided by this plugin).
- Query names are the filenames (without `.scm`), e.g. `queries/go/go_nav_func_decl.scm` is queried as `go_nav_func_decl`.

Capture names are part of the contract between Lua and `.scm`:
- `@func_decl_start`: where the cursor should land for a function/method.
- `@func_node` (optional): a whole function-like node; used when present to avoid “walk up parents”.
- `@func_name`: used for function-call navigation.
- `@identifier`: used for identifier navigation.

If you change capture names in `.scm`, you must update the corresponding Lua module logic.

### Navigation modules

#### Function/method declaration navigation
- `lua/go-sparrow/go_nav_func_decl.lua`
- Uses the named query `go_nav_func_decl` and moves to the next/previous `@func_decl_start`.
- Has an optimization for “previous” that searches visible range first, then falls back to full-buffer search.
- Supports counts via `vim.v.count`.

#### Function-call / expression navigation
- `lua/go-sparrow/go_nav_func_equal.lua`
- Uses named queries per language:
  - `func_calls` (capture `@func_name`)
  - `expressions` (capture `@func_name`)
- Maintains a per-query-type cache keyed by `(bufnr, changedtick)` and also searches visible range first.
- Filters out “noisy” calls via `ignore_list` (e.g. logging helpers, `len`, `make`).

#### Identifier navigation
- `lua/go-sparrow/go_nav_identifier.lua`
- Uses inline query strings (not `queries/<lang>/…`) for Go/Lua/Rust.
- Caches matches per `(bufnr, changedtick)` and expands beyond the visible range only when needed.
- Intentionally skips identifiers named `err`.

### Range actions (operate on the enclosing function)
- `lua/go-sparrow/range_action.lua`
- Finds the nearest enclosing function-like node at the cursor using a language-specific query:
  - default: `go_nav_func_decl`
  - lua: `go_nav_range_action` (has richer patterns and `@func_node` captures)
- Exposes actions:
  - `yank_function()` (copies function text to `*` register and briefly highlights the range)
  - `visual_function()` (selects the range in visual mode)
  - `delete_function()` (visual-select then delete)

## Extending language support (what usually needs changing)
- Add or update query files under `queries/<newlang>/` with the same query names/capture names expected by the Lua modules.
- For function-call/expression navigation, add `<newlang>` to `QUERY_NAMES` in `lua/go-sparrow/go_nav_func_equal.lua`.
- For identifier navigation, add a `<newlang>` entry to `QUERY_STRINGS` in `lua/go-sparrow/go_nav_identifier.lua` (it does not use `queries/<lang>/` today).