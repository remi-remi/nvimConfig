vim.api.nvim_create_autocmd("FileType", {
   pattern = { "lua", "vim", "bash", "javascript", "typescript", "tsx", "html", "css", "json", "markdown", "SQL" },
   callback = function()
      vim.treesitter.start()
   end,
})

return {}
