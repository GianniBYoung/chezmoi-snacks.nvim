# Chezmoi.nvim

Snacks.nvim picker for Chezmoi managed dotfiles!

Also adds Neovim commands to:

- `add`

- `forget`

- `re-add`
  - Chezmoi does not overwrite template files and neither will this command

- `update` Chezmoi's source

## Installation

Install the plugin and call `setup()`. Here is an example with Lazy:

```lua
{
    "GianniBYoung/chezmoi-snacks.nvim",
    dependencies = { { "folke/snacks.nvim" } },
    config = true,
}
```

## Pre-Reqs

- [Chezmoi](https://www.chezmoi.io/)

- [snacks.nvim](https://github.com/folke/snacks.nvim)

## Usage

- `:ChezmoiDotfiles` -> Open picker populated with Chezmoi managed dot files
  - This opens the file in chezmoi's source dir

- `:ChezmoiDotfiles live` -> Open picker populated with (Live) Chezmoi managed dot files
  - This opens the actual dotfile on your system

- `:ChezmoiAdd` -> `add` the current file to Chezmoi

- `:ChezmoiReAdd` -> `re-add` the current file to Chezmoi

- `:ChezmoiForget` -> `forget` the current file from Chezmoi

- `:ChezmoiUpdate` -> Pull down the remote source

### Lua API

```lua
require("chezmoi").dotfiles()
require("chezmoi").dotfiles({ live_dots = true })
```

### Options
The available options for `dotfiles()` are:
- `live_dots` bool(false) - Populate the picker with the actual dotfiles your system is using

## Contributing

If this plugin is missing functionality for your use case please open an issue or submit a PR!
