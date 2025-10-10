-- Copy to system clipboard using Ctrl+C


if not vim.g.neovide then
   vim.api.nvim_set_keymap('v', '<C-c>', '"+y', { noremap = true, silent = false })  -- visual
   vim.api.nvim_set_keymap('n', '<C-c>', '"+yy', { noremap = true, silent = false }) -- normal
end
