<h1 align="center">🔎 linkview.nvim</h1>
<p align="center"><i>Find and display links from a variety of search contexts</i></p>

# **PLEASE NOTE:** Linkview is a fork of [urlview.nvim](https://github.com/axieax/urlview.nvim)

## changes
the only modifications i've introduced are regex parsing for file paths
and a change in how they are opened so that url prefixes aren't stripped for
display and readded after. that way file paths are differentiated from
other collected paths visually for the user and also during the open function.
the regex lets urlview pick up local, absolute, or home(~) paths which is
especially useful to me for traversing markdown style links.

if you try to open a path that can't be found a prompt will ask if you want
to open it anyways before attempting to.

## merge upstream?
the original plug in seems largely abandoned, and although links were on their roadmap
it's been years since any large contributions so I think well just leave it here as is.
happy to merge but don't care to pursue it. im not like a neovim plugin developer
or whatever, i just wanted this to work for me.

## in summary
**i have no plan to maintain these changes,
these modifications are untested, clandestine, & hackish.**

*use with caution...*


the readme following is as written at the time of my fork

# original readme
---

✨ UrlView is an extensible plugin for the [Neovim](https://neovim.io) text editor which essentially:

1. Finds URLs from a variety of **search contexts** (e.g. from a buffer, file, plugin URLs)
2. Displays these URLs in a **picker**, such as the built-in `vim.ui.select`, [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim), or [fzf-lua](https://github.com/ibhagwan/fzf-lua).
3. Performs **actions** on selected URLs, such as navigating to the URL in your preferred browser, or copying the link to your clipboard

🎯 Additional features and example use cases include:

- Easily visualise all the URLs in a buffer or file (e.g. links in your Markdown documents)
- Quickly accessing repo webpages for installed Neovim plugins (life-saver for config updates or browsing plugin documentation)
- Ability to register custom searchers (e.g. Jira ticket numbers), pickers and actions (please see [docs](doc/urlview.txt) or `:h urlview.search-custom`)
- Jumping to the previous or next URL in the active buffer (and opening the URL in your browser)

> Please note that currently, this plugin only detects URLs beginning with a `http(s)` or `www` prefix for buffer and file search, but there are plans to support a more general pattern (see [🗺️ Roadmap](https://github.com/axieax/urlview.nvim/issues/3)).

## 📸 Screenshots

### 📋 Buffer Links

`:UrlView` or `:UrlView buffer`

![buffer-demo](https://user-images.githubusercontent.com/62098008/161417569-e8103fc4-a009-4c4f-95a7-ea7e22cbb3df.png)

### 🔌 Plugin Links

`:UrlView lazy`, `:UrlView packer`, or `:UrlView vimplug` depending on your plugin manager of choice

![packer-demo](https://user-images.githubusercontent.com/62098008/161417652-fd514310-a926-4ec7-af28-b2cfa3aa4b19.png)

## ⚡ Requirements

- This plugin supports **Neovim v0.7** or later.
- Please find the appropriate _\*-compat_ Git tag if you need legacy support for previous Neovim versions, such as [v0.6-compat](https://github.com/axieax/urlview.nvim/tree/v0.6-compat) for nvim v0.6, although these versions will no longer receive any new updates or features.
- For Neovim versions prior to v0.6 or Vanilla [Vim](https://www.vim.org/) support, please check out [urlview.vim](https://github.com/strboul/urlview.vim) as an alternative plugin.

## 🚀 Usage

### Searching contexts

1. Use the command `:UrlView` to see all the URLs in the current buffer.

- For your convenience, feel free to setup a keybind for this using `vim.keymap.set`:

  ```lua
  vim.keymap.set("n", "\\u", "<Cmd>UrlView<CR>", { desc = "View buffer URLs" })
  vim.keymap.set("n", "\\U", "<Cmd>UrlView packer<CR>", { desc = "View Packer plugin URLs" })
  ```

- You can also hit `:UrlView <tab>` to see additional contexts that you can search from
  - e.g. `:UrlView packer` to view links for installed [packer.nvim](https://github.com/wbthomason/packer.nvim) plugins

2. You can optionally select a link to bring it up in your browser.

### Buffer URL navigation

1. You can use `[u` and `]u` (default bindings) to jump to the previous and next URL in the buffer respectively.
2. If desired, you can now press `gx` to open the URL under the cursor in your browser, with netrw.
3. This keymap can be altered under the `jump` config option.

## 📦 Installation

Install this plugin with your package manager of choice. You can lazy load this plugin by the `UrlView` command if desired.

- [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use("axieax/urlview.nvim")
```

- [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
"axieax/urlview.nvim"
```

## ⚙️ Configuration

This plugin supports plug-n-play, meaning you can get it up and running without any additional setup.

However, you can customise the [default options](lua/urlview/config/default.lua) using the `setup` function:

```lua
require("urlview").setup({
  -- custom configuration options --
})
```

Please check out the [documentation](doc/urlview.txt) for configuration options and details.

## 🎨 Pickers

### ✔️ Native (vim.ui.select)

You can customise the appearance of `vim.ui.select` with plugins such as [dressing.nvim](https://github.com/stevearc/dressing.nvim) and [telescope-ui-select.nvim](https://github.com/nvim-telescope/telescope-ui-select.nvim). In the demo images above, I used [dressing.nvim](https://github.com/stevearc/dressing.nvim)'s Telescope option, which allows me to further filter and fuzzy search through my entries.

### 🔭 Telescope

- Optional picker option
- Additional requirements (only if you're using this picker): [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
- You can use Telescope as your `default_picker` using the `require("urlview").setup` function
- Alternatively, you can specify a picker dynamically with `:UrlView <ctx> picker=telescope`

### 📑 fzf-lua

- Optional picker option
- Additional requirements (only if you're using this picker): [fzf-lua](https://github.com/ibhagwan/fzf-lua)
- You can use fzf-lua as your `default_picker` using the `require("urlview").setup` function
- Alternatively, you can specify a picker dynamically with `:UrlView <ctx> picker=fzf_lua`

## 🚧 Stay Updated

More features are continually being added to this plugin (see [🗺️ Roadmap](https://github.com/axieax/urlview.nvim/issues/3)). Feel free to file an issue or create a PR for any features / fixes :)

It is recommended to subscribe to the [🙉 Breaking Changes](https://github.com/axieax/urlview.nvim/issues/37) thread to be updated on potentially breaking changes to this plugin, as well as resolution strategies.
