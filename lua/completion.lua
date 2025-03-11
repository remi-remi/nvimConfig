local cmp = require('cmp')

cmp.setup({
  mapping = cmp.mapping.preset.insert({
    -- Navigation
    ['<C-Space>'] = cmp.mapping.complete(), -- Affiche la complétion
    ['<C-e>'] = cmp.mapping.abort(), -- Ferme la complétion
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Insère la sélection

    -- TAB pour naviguer dans les suggestions
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
    { name = 'nvim_lsp' }, -- Complétion depuis LSP (y compris snippets et enums)
    { name = 'buffer' },   -- Complétion des mots du fichier en cours
    { name = 'path' },     -- Complétion des chemins de fichiers
  }),
  experimental = {
    ghost_text = true, -- Affiche une prévisualisation légère en gris
  },
  formatting = {
    format = function(entry, vim_item)
      -- Étiquettes abrégées pour compresser l'affichage
      local kind_labels = {
        Text = "txt", Method = "m()", Function = "f()", Constructor = "cnstrctor",
        Field = "fild", Variable = "var", Class = "cls", Interface = "intrfc",
        Module = "mod", Property = "prop", Unit = "unit", Value = "val",
        Enum = "enum", Keyword = "kwrd", Snippet = "snip", Color = "clr",
        File = "file", Reference = "ref", Folder = "dir", EnumMember = "enuMbr",
        Constant = "cnst", Struct = "struct", Event = "evnt", Operator = "op",
        TypeParameter = "tparam"
      }
      vim_item.kind = kind_labels[vim_item.kind] or vim_item.kind
      vim_item.menu = ({
        nvim_lsp = "LSP",
        buffer = "BUF",
        path = "PTH",
      })[entry.source.name]
      return vim_item
    end,
  },
  window = {
    completion = cmp.config.window.bordered(), -- Ajoute des bordures autour du menu de complétion
    documentation = cmp.config.window.bordered(), -- Affiche la documentation sous forme de popup
  },
})

-- 🔥 **Correction : Mode `/` et `:` avec `preset.cmdline()`**
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(), -- 🔥 Correction : Utilisation correcte de la navigation
  sources = cmp.config.sources({
    { name = 'path' },    -- Complétion des chemins de fichiers
    { name = 'cmdline' }, -- Complétion des commandes Neovim
    { name = 'buffer' },  -- Complétion du texte dans les fichiers ouverts
  })
})

