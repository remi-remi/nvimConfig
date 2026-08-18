return {
   "nvim-treesitter/nvim-treesitter",
   branch = "master",
   lazy = false,
   build = ":TSUpdate",
   -- Détection Arch Linux seulement
   config = function()
      vim.opt.runtimepath:prepend(vim.fn.stdpath("data") .. "/lazy/nvim-treesitter")

      require("nvim-treesitter.configs").setup({
         ensure_installed = {
            "markdown",
            "markdown_inline",
            "lua",
            "javascript",
            "typescript",
            "tsx",
            "json",
            "jsonc",
            "html",
            "css",
            "scss",
            "yaml",
            "bash",
            "sql",
            "dockerfile",
         },
         highlight = { enable = true },
         textobjects = { enable = true },
      })

      vim.api.nvim_create_autocmd({ "FileType", "BufEnter" }, {
         pattern = { "markdown", "lsp_float" },
         callback = function()
            vim.treesitter.start(0, "markdown")
         end,
      })
   end,
}
