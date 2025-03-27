vim.g.clipboard = {
    name = 'wl-clipboard',
    copy = {
        ['+'] = 'wl-copy --type text/plain',
        ['*'] = 'wl-copy --type text/plain',
    },
    paste = {
        ['+'] = 'wl-paste --no-newline',
        ['*'] = 'wl-paste --no-newline',
    },
    cache_enabled = 1,
}


-- Mapping pour copier/coller avec Ctrl+Maj+C/V
vim.api.nvim_set_keymap('v', '<C-c>', '"+y', { noremap = true, silent = true }) -- Copier en mode visuel
vim.api.nvim_set_keymap('n', '<C-c>', '"+yy', { noremap = true, silent = true }) -- Copier une ligne en mode normal


-- keymaps.lua
--local opts = { noremap = true, silent = true }

-- Example key mapping for saving (should i remove it ?)
--vim.api.nvim_set_keymap('n', '<Leader>w', ':w<CR>', opts)

-- Project explorer
vim.api.nvim_set_keymap('n', '<Leader>e', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

-- Aller à l'onglet suivant avec Ctrl + Maj + Flèche Droite
vim.api.nvim_set_keymap('n', '<C-A-Right>', ':tabnext<CR>', { noremap = true, silent = false })

-- Aller à l'onglet précédent avec Ctrl + Maj + Flèche Gauche
vim.api.nvim_set_keymap('n', '<C-A-Left>', ':tabprevious<CR>', { noremap = true, silent = false })

-- find file,go to a string
local utils = require('utils')

vim.api.nvim_set_keymap(
  'n',
  '<M-CR>',
  ":lua local path = require('utils').resolve_relative_path(vim.fn.expand('<cfile>')); if path then vim.cmd('tabedit ' .. path) else print('File not found') end<CR>",
  { noremap = true, silent = true }
)

