-- Autocommande pour les fichiers avec extension .fr.txt
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  pattern = "*.fr.txt",
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.spelllang = "fr"
  end,
})

