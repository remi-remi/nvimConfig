-- <leader>e → toggle NvimTree sans changer de focus
vim.keymap.set("n", "<leader>e", function()
  local api = require("nvim-tree.api")
  local current_win = vim.api.nvim_get_current_win()

  api.tree.toggle()

  -- Rendre le focus à la fenêtre d’origine
  vim.defer_fn(function()
    if vim.api.nvim_win_is_valid(current_win) then
      vim.api.nvim_set_current_win(current_win)
    end
  end, 50) -- 50ms pour laisser le temps au toggle
end, { noremap = true, desc = "Toggle NvimTree visibility (no focus)" })


-- <A-e> → toggle focus entre tree et fichier
vim.keymap.set("n", "<A-e>", function()
  local api = require("nvim-tree.api")

    api.tree.toggle()

end, { noremap = true, desc = "Toggle focus NvimTree <-> buffer" })



vim.keymap.set('n', '<Leader>ff', ':Telescope find_files<CR>', { noremap = true })
vim.keymap.set('n', '<Leader>fg', ':Telescope live_grep<CR>', { noremap = true })

