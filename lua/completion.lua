local cmp = require('cmp')

cmp.setup({
  mapping = cmp.mapping.preset.insert({
    -- Navigation
    ['<C-Space>'] = cmp.mapping.complete(), -- Open completion menu
    ['<C-e>'] = cmp.mapping.abort(), -- Close completion menu
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Confirm selection

    -- TAB to navigate suggestions
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
      else
        fallback()
      end
    end, { "i", "s" }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' }, -- Completion from LSP (including snippets and enums)
    { name = 'buffer' },   -- Completion from the current buffer
    { name = 'path' },     -- Completion for file paths
  }),
  experimental = {
    ghost_text = true, -- Display a light gray preview text
  },
  formatting = {
    format = function(entry, vim_item)
      -- Shortened labels for better readability
      local kind_labels = {
        Text = "", Method = "m()", Function = "󰊕", Constructor = "cnstrctr",
        Field = "󰗧", Variable = "", Class = "cls", Interface = "intrfc",
        Module = "mod", Property = "", Unit = "unit", Value = "val",
        Enum = "enum", Keyword = "kwrd",  Color = "",
        File = "", Reference = "ref", Folder = "", EnumMember = "enuMbr",
        Constant = "", Struct = "struct", Event = "󰯪", Operator = "",
        TypeParameter = "tparam"
      }

       -- If the item is a snippet, make sure it's labeled correctly
      if vim_item.kind == "Snippet" then
        vim_item.kind = ""  -- Assign the snippet icon
      else
        vim_item.kind = kind_labels[vim_item.kind] or vim_item.kind
      end

      vim_item.menu = ({
        lsp = "",   -- LSP icon
        buffer = "󰅍", -- Buffer icon
        path = ""   -- Path icon
      })[entry.source.name]
      return vim_item
    end,
  },
  window = {
    completion = cmp.config.window.bordered(), -- Add borders around the completion menu
    documentation = cmp.config.window.bordered(), -- Display documentation in a popup window
  },
})

-- Configure completion for `/` and `:` using `preset.cmdline()`
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(), -- Ensure proper navigation
  sources = cmp.config.sources({
    { name = 'path' },    -- Completion for file paths
    { name = 'cmdline' }, -- Completion for Neovim commands
    { name = 'buffer' },  -- Completion from open buffers
  })
})

