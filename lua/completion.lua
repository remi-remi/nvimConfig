-- cmp.lua

local cmp = require('cmp')

cmp.setup({
  snippet = {
    -- Provide a dummy function since you don't use snippets
    expand = function(args)
      -- Do nothing
    end,
  },
  mapping = cmp.mapping.preset.insert({
    -- Your key mappings
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({
          -- could be Insert or Replace
          behavior = cmp.ConfirmBehavior.Insert,
          select = true,
    }),  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    ---{ name = 'vsnip' }, -- Remove if not using snippets
  }
  , {
  { name = 'buffer' },
  })
})

-- Set up cmdline completion (optional)
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' },
    { name = 'cmdline' },
    { name = 'buffer' },
  })
})

