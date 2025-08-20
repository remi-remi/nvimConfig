-- UI navigation (tabs, splits, etc.)
vim.keymap.set('n', '<C-A-Right>', ':tabnext<CR>', { noremap = true, silent = false })
vim.keymap.set('n', '<C-A-Left>', ':tabprevious<CR>', { noremap = true, silent = false })
vim.keymap.set('n', '<Leader>n', ':tabnew<CR>', { noremap = true, silent = true })

-- exit from terminal mode with the same behavior than any other modes
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { noremap = true, silent = true, desc = "Exit terminal mode" })
