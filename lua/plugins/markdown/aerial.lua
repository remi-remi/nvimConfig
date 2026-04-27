return {
   "stevearc/aerial.nvim",
   dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-web-devicons",
   },
   config = function()
      require("aerial").setup({
         layout = {
            max_width = 40,
            width = 25,
            min_width = 10,
         },
      })
      vim.keymap.set("n", "<leader>o", "<cmd>AerialToggle<cr>", { noremap = true })
   end,
}
