-- plugins/config/completion-config.lua

local cmp = require("cmp")

-- Setup for `/`
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Setup for `:`
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' },
    { name = 'cmdline' },
    { name = 'buffer' },
  })
})

-- Final return (anonymous table for require)
return {
  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
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
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'path' },
  }),

  experimental = {
    ghost_text = true,
  },

  formatting = {
    format = function(entry, vim_item)
      local kind_labels = {
        Text = "", Method = "m()", Function = "󰊕", Constructor = "cnstrctr",
        Field = "󰗧", Variable = "", Class = "cls", Interface = "intrfc",
        Module = "mod", Property = "", Unit = "unit", Value = "val",
        Enum = "enum", Keyword = "kwrd",  Color = "",
        File = "", Reference = "ref", Folder = "", EnumMember = "enuMbr",
        Constant = "", Struct = "struct", Event = "󰯪", Operator = "",
        TypeParameter = "tparam", Snippet = ""
      }

      vim_item.kind = kind_labels[vim_item.kind] or vim_item.kind

      vim_item.menu = ({
        nvim_lsp = "",
        buffer = "󰅍",
        path = "",
        cmdline = ":",
      })[entry.source.name]

      return vim_item
    end,
  },

  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
}

