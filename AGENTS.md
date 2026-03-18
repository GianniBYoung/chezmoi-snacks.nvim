# AGENTS.md

Essential context for agents working in the `chezmoi-snacks.nvim` repository.

## Project Overview

**Type**: Neovim plugin (snacks.nvim picker)

**Purpose**: Snacks.nvim picker for Chezmoi-managed dotfiles with Vim commands for common Chezmoi operations.

**Language**: Lua

**Dependencies**:
- [snacks.nvim](https://github.com/folke/snacks.nvim) (required - provides picker UI)
- [Chezmoi](https://www.chezmoi.io/) CLI tool (required - must be in PATH)

## Repository Structure

```
lua/chezmoi/
├── init.lua       # Plugin entry point: setup(), dotfiles picker, Vim commands
└── health.lua     # Health check (:checkhealth chezmoi)
```

## Code Organization

### `init.lua`

- `M.setup()` - Registers all user commands (`:ChezmoiAdd`, `:ChezmoiReAdd`, `:ChezmoiForget`, `:ChezmoiUpdate`, `:ChezmoiDotfiles`)
- `M.dotfiles(opts)` - Opens snacks.nvim picker with Chezmoi managed files
- `get_dotfiles()` - Local helper that shells out to `find` to list files from Chezmoi source dir
- `set_buffer_filetype(path)` - Detects and sets filetype for template files

### `health.lua`

- Checks if `chezmoi` binary is available
- Checks if `snacks.nvim` is installed

## Code Conventions

### Style
- **Indentation**: Tabs
- **Quotes**: Double quotes
- **Naming**: `snake_case` for functions and variables
- **Module pattern**: `local M = {}` / `return M`

### Key Patterns

**Shell commands**: Uses `vim.fn.shellescape()` for safe shell argument passing

**Picker items**: Each item has `text`, `file`, `source_path`, and `display_path` fields

**File path transformations**: Chezmoi `dot_` prefix becomes `.`, `.tmpl` suffix is stripped

## Chezmoi Integration

All Chezmoi operations shell out to the `chezmoi` CLI:
- Source dir resolved once at load time via `io.popen("chezmoi source-path")`
- File discovery via `find` command excluding `.git/` and hidden files (except `.chezmoi*`)
- User commands use `vim.fn.system()` with `vim.fn.shellescape()` for safety

## Commands

**No build/test/lint** - pure Lua plugin, manual testing only.

**Health check**: `:checkhealth chezmoi`

**User commands** (available after `require("chezmoi").setup()`):
- `:ChezmoiDotfiles` - Open picker (source files)
- `:ChezmoiDotfiles live` - Open picker (live dotfiles)
- `:ChezmoiAdd` - Add current file to Chezmoi
- `:ChezmoiReAdd` - Re-add current file
- `:ChezmoiForget` - Remove current file from Chezmoi
- `:ChezmoiUpdate` - Pull latest config

## Gotchas

- `vim` and `Snacks` globals are provided by Neovim/snacks.nvim at runtime; LSP warnings about "undefined global" are false positives
- Chezmoi source dir is resolved once at `require("chezmoi")` time - if chezmoi isn't installed, this will error on load
- Template files (`.tmpl`) need explicit filetype detection after opening since the source filename doesn't match the real extension

## Git Workflow

- Primary branch: `main`
- Commit style: loose conventional commits (`feat:`, `chore:`, `feat!:` for breaking)
- Features via PRs from short-lived branches

## Quick Reference

**Testing locally**:
1. Make changes
2. Restart Neovim or clear module cache: `:lua package.loaded['chezmoi'] = nil`
3. Re-run setup: `:lua require('chezmoi').setup()`
4. Test commands/picker manually
