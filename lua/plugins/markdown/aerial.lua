return {
   "stevearc/aerial.nvim",
   branch = "nvim-0.11",
   dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-web-devicons",
   },
   config = function()
      require("core.pin-notice")("aerial.nvim", "nvim-0.11 branch", 0, 11)

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
