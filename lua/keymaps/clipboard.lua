-- Copy to system clipboard using Ctrl+C
vim.api.nvim_set_keymap('v', '<C-c>', '"+y', { noremap = true, silent = false }) -- visual
vim.api.nvim_set_keymap('n', '<C-c>', '"+yy', { noremap = true, silent = false }) -- normal
