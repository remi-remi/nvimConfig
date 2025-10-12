local cmp = require("cmp")
-- Setup for `/`
cmp.setup.cmdline('/', {
   mapping = cmp.mapping.preset.cmdline(),
   sources = {
      { name = 'buffer' }
   }
})

-- filename source

local filename_source = {}

filename_source.new = function()
   local self = setmetatable({}, { __index = filename_source })
   return self
end

function filename_source:complete(_, callback)
   local filename = vim.fn.expand("%:t:r")
   callback({
      { label = filename, kind = cmp.lsp.CompletionItemKind.File },
   })
end

cmp.register_source("filename", filename_source.new())
--

-- Setup for `:`
cmp.setup.cmdline(':', {
   mapping = cmp.mapping.preset.cmdline(),
   sources = cmp.config.sources({
      { name = 'cmdline' },
      { name = 'nvim_lsp' },
      { name = 'luasnip' },
      { name = 'buffer' },
      { name = 'path' },
      { name = 'filename' },
   }),
})

return {

   snippet = {
      expand = function(args)
         require("luasnip").lsp_expand(args.body)
      end,
   },

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
      { name = 'luasnip' },
      { name = 'buffer' },
      { name = 'path' },
      { name = 'filename' }
   }),

   experimental = {
      ghost_text = false,
   },

   formatting = {
      format = function(entry, vim_item)
         local kind_labels = {
            Text = "",
            Method = "m()",
            Function = "󰊕",
            Constructor = "cnstrctr",
            Field = "󰗧",
            Variable = "",
            Class = "cls",
            Interface = "intrfc",
            Module = "mod",
            Property = "",
            Unit = "unit",
            Value = "val",
            Enum = "enum",
            Keyword = "kwrd",
            Color = "",
            File = "",
            Reference = "ref",
            Folder = "",
            EnumMember = "enuMbr",
            Constant = "",
            Struct = "struct",
            Event = "󰯪",
            Operator = "",
            TypeParameter = "tparam",
            Snippet = ""
         }

         vim_item.kind = kind_labels[vim_item.kind] or vim_item.kind

         vim_item.menu = ({
            nvim_lsp = "",
            luasnip = "",
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
