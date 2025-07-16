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



vim.api.nvim_create_user_command("Tff", "Telescope find_files", { desc = "Open Telescope find_files" })
vim.api.nvim_create_user_command("Tlg", "Telescope live_grep", { desc = "Open Telescope live_grep" })

vim.keymap.set("n", "<leader>f", function()
   vim.lsp.buf.format()
end, { noremap = true, silent = true })
