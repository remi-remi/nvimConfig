-- Bootstrap lazy.nvim plugin manager
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Plugins table
local plugins = {
  -- Theme
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
  },
  -- LSP configurations
  {
    'neovim/nvim-lspconfig',
  },
  -- nvim-tree.lua pour l'explorateur de fichiers
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require('nvim-tree').setup(require('nvim-tree-config'))
    end,
  },
  -- Plugin pour les icônes
  {
    'nvim-tree/nvim-web-devicons',
    lazy = true,
  },
  -- Mason for managing LSP servers
  {
    'williamboman/mason.nvim',
    config = function()
      require('mason').setup()
    end
  },
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = { 'neovim/nvim-lspconfig' },
    config = function()
      require('mason-lspconfig').setup()
    end
  },
  -- Auto-completion plugin
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
    },
  },
  {
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} }
  },
  -- Plugins pour la gestion des couleurs
  {
    "ap/vim-css-color",
  },
  {
    "NvChad/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup()
    end
  },
  {
    "max397574/colortils.nvim",
    config = function()
      require("colortils").setup()
    end
  }
}

-- Set up lazy.nvim with the plugins
require('lazy').setup(plugins)

