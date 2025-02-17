-- settings.lua

-- Set leader key
vim.g.mapleader = ' '

-- Enable line numbers
vim.opt.number = true
vim.opt.relativenumber = false

-- Set encoding
vim.opt.encoding = 'utf-8'      -- Définit l'encodage de Neovim
vim.opt.fileencoding = 'utf-8'  -- Définit l'encodage des fichiers

vim.opt.expandtab = true      -- Remplace les tabs par des espaces
vim.opt.shiftwidth = 3        -- Définit l'indentation automatique à X espaces
vim.opt.softtabstop = 3       -- Nombre d'espaces quand on appuie sur TAB
vim.opt.tabstop = 3           -- Nombre d'espaces qu'un tab représente


-- Enable syntax highlighting
vim.cmd('syntax on')
