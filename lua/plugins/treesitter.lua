return {
   {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      lazy = true, -- ne charge jamais le plugin au runtime
      cmd = { "TSInstall", "TSUpdate", "TSInstallInfo" },
      config = function()
         require("nvim-treesitter.configs").setup({
            ensure_installed = { "lua", "vim", "bash", "javascript", "typescript", "tsx", "html", "css", "json", "markdown", "sql", "markdown_inline" },
            highlight = { enable = false },
            indent = { enable = false },
         })
      end,
   },
   {
      name = "treesitter-start",
      dir = vim.fn.stdpath("config"),
      event = "FileType",
      config = function()
         vim.api.nvim_create_autocmd("FileType", {
            pattern = { "lua", "vim", "bash", "javascript", "typescript", "javascriptreact", "typescriptreact", "html", "css", "json", "markdown", "SQL", "markdown_inline" },
            callback = function()
               local ok, err = pcall(vim.treesitter.start)
               if not ok then
                  vim.notify("Treesitter: " .. err, vim.log.levels.WARN)
               end
            end,
         })
      end,
   },
}
