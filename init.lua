-- Load plugins
require('plugins')
-- Load settings
require('settings')

vim.cmd('colorscheme tokyonight')

require('keymaps')

require('completion')
require('fr')

-- Load LSP configurations
require('lsp')
require('lsp.web_dev')
require('lsp.bash')
require('lsp.ruby')
require('lsp.lua')
require('lsp.java')

-- Undo persistance
-- run mkdir -p ~/.local/state/nvim/undo
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("state") .. "/undo"

