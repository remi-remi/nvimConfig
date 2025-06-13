# Neovim Config Notes (Lua-first)

## TL;DR

- Use `vim.opt` for most config, it's the modern & clean way
- `require("plugin").setup({...})` configures a plugin (plugin must export `setup`)
- Lazy.nvim uses a table to define plugins, manages cloning & loading
- Always reference Lua files from the `lua/` root, use `.` instead of `/`

---

## Options: Buffer-local & Window-local

```lua
vim.opt.parameter = true                -- global + local (preferred modern API)
vim.o.parameter = true                  -- global only
vim.bo.parameter = true                 -- buffer-local
vim.wo.parameter = true                 -- window-local

-- More advanced, programmatic style:
vim.api.nvim_buf_set_option(0, 'modifiable', true)
```

---

## Autocommands (react to events)

```lua
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*.lua",
  callback = function()
    vim.bo.modifiable = true
  end,
})
```

With group:

```lua
vim.api.nvim_create_augroup("MyGroup", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
  group = "MyGroup",
  pattern = "*.lua",
  callback = function()
    print("Lua file saved!")
  end,
})
```

---

## Custom User Commands

```lua
vim.api.nvim_create_user_command("MyEcho", function(opts)
  print("Hello " .. (opts.args or "world"))
end, { nargs = "?" })
```

Usage:

```
:MyEcho
:MyEcho blah
```

---

## Plugin setup with `.setup({})`

You can configure most plugins using:

```lua
require("plugin-name").setup({
  key_name = "value",
  nested = {
    other = {
      something = true,
    }
  }
})
```

Note: this is **Lua tables**, not JSON:
- use `=` instead of `:`
- no quotes for keys (unless special characters)

---

## How `require()` works in Lua

- `require` is a Lua native function
- Always relative to the `lua/` directory
- Uses `.` instead of `/`
- No file extension

Example:

```lua
require("core.settings")      -- loads lua/core/settings.lua
require("plugins.onedark")    -- loads lua/plugins/onedark.lua
```

---

## Lazy.nvim Structure & Logic

You define a list of plugin "specs" (as tables), and pass it to Lazy:

```lua
local plugins = {
  {
    "nvim-tree/nvim-tree.lua",
    config = function()
      require("nvim-tree").setup({
        hijack_netrw = true,
        view = { width = 30 },
      })
    end,
  },
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    lazy = false,
  }
}

require("lazy").setup(plugins)
```

Each plugin spec can contain:

- `"plugin/repo"` (required)
- `lazy = true|false`
- `event = "BufReadPre"` or `cmd = "CmdName"`
- `priority`, `dependencies`, `name`, etc.
- `config = function() ... end`
- `opts = { ... }` (if plugin supports automatic setup)

---

## Summary

You don’t use `require("plugin").setup()` manually in `init.lua` anymore.
Instead, you define everything inside plugin tables, and Lazy handles:
- `git clone`
- `require()`
- calling `.setup()` (via `config` or `opts`)
