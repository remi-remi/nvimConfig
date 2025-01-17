
-- Dans votre init.lua ou un fichier de configuration approprié

return {
  -- Désactiver netrw au démarrage de Neovim
  disable_netrw = true,
  hijack_netrw = true,
  -- Mettre à jour le répertoire de travail actuel de Neovim
  update_cwd = true,
  -- Afficher les icônes de diagnostics (erreurs, avertissements)
  diagnostics = {
    enable = true,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    },
  },
  -- Configuration de l'affichage
  view = {
    width = 30,
    side = 'left',
    -- Vous pouvez retirer 'mappings' ici
  },
  -- Configuration des icônes
  renderer = {
    icons = {
      glyphs = {
        default = "",
        symlink = "",
        folder = {
          arrow_closed = "",
          arrow_open = "",
          default = "",
          open = "",
          empty = "",
          empty_open = "",
          symlink = "",
          symlink_open = "",
        },
        git = {
          unstaged = "✗",
          staged = "✓",
          unmerged = "",
          renamed = "➜",
          untracked = "★",
          deleted = "",
          ignored = "◌",
        },
      },
    },
  },
  -- Activer l'intégration Git
  git = {
    enable = true,
    ignore = false,
  },
  -- Définir les mappages de touches personnalisés avec 'on_attach'
  on_attach = function(bufnr)
    local api = require('nvim-tree.api')

    local function opts(desc)
      return {
        desc = 'nvim-tree: ' .. desc,
        buffer = bufnr,
        noremap = true,
        silent = true,
        nowait = true,
      }
    end

    -- Mappages par défaut (optionnel, si vous voulez les garder)
    api.config.mappings.default_on_attach(bufnr)

    -- Vos mappages personnalisés
    vim.keymap.set('n', 'v', api.node.open.vertical, opts('Open: Vertical Split'))
    vim.keymap.set('n', 's', api.node.open.horizontal, opts('Open: Horizontal Split'))
    -- Ajoutez d'autres mappages si nécessaire
  end,
}

