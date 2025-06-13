-- UI navigation (tabs, splits, etc.)
vim.keymap.set('n', '<C-A-Right>', ':tabnext<CR>', { noremap = true, silent = false })
vim.keymap.set('n', '<C-A-Left>', ':tabprevious<CR>', { noremap = true, silent = false })
vim.keymap.set('n', '<Leader>n', ':tabnew<CR>', { noremap = true, silent = true })

