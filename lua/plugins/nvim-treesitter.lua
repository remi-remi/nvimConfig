return {
   "nvim-treesitter/nvim-treesitter",
   build = ":TSUpdate",
   event = { "BufReadPost", "BufNewFile" },
   config = function()
      require("nvim-treesitter.configs").setup({
         ensure_installed = {
            "lua",
            "vim",
            "bash",
            "javascript",
            "typescript",
            "tsx",
            "html",
            "css",
            "json",
            "yaml",
         },
         highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
         },
         indent = {
            enable = true, -- can be dissabled because prettier manage the full indent, but if no conflict it will do the smart indent
         },
      })
   end,
}
