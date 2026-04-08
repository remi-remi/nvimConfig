return {
   "folke/tokyonight.nvim",
   lazy = false,
   priority = 1000,
   config = function()
      require("tokyonight").setup({
         style = "moon", -- 'storm', 'night', 'moon', 'day'
         transparent = true,
         terminal_colors = true,
         styles = {
            sidebars = "transparent",
            floats = "transparent",
         },
      })
   end,
}
