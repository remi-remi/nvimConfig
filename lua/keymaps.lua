
-- Copier dans le presse-papier système
vim.api.nvim_set_keymap('v', '<C-c>', '"+y', { noremap = true, silent = false })
vim.api.nvim_set_keymap('n', '<C-c>', '"+yy', { noremap = true, silent = false })

-- keymaps.lua
local opts = { noremap = true, silent = true }

-- Example key mapping for saving (should i remove it ?)
vim.api.nvim_set_keymap('n', '<Leader>w', ':w<CR>', opts)

-- Project explorer
vim.api.nvim_set_keymap('n', '<Leader>e', ':NvimTreeToggle<CR>', { noremap = true, silent = true })


