-- <leader>e → toggle NvimTree sans changer de focus
vim.keymap.set("n", "<A-e>", function()
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
vim.keymap.set("n", "<leader>e", function()
   local api = require("nvim-tree.api")

   api.tree.toggle()
end, { noremap = true, desc = "Toggle focus NvimTree <-> buffer" })



vim.keymap.set("n", "<leader>f", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
vim.keymap.set("n", "<leader>g", "<cmd>Telescope live_grep<cr>", { desc = "Live grep" })
vim.keymap.set("n", "<leader>/", "<cmd>Telescope current_buffer_fuzzy_find<cr>",
   { desc = "Fuzzy search in current buffer" })

-- F not f cause save trigger format, if can be used to format, we barely need a shortcut to format
vim.keymap.set("n", "<leader>F", function()
   vim.lsp.buf.format()
end, { noremap = true, silent = true })
