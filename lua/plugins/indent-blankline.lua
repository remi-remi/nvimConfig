return {
   "lukas-reineke/indent-blankline.nvim",
   main = "ibl",
   event = "VeryLazy",
   opts = {
      indent = {
         char = "│", -- tu peux mettre "▏", "┃", etc.
      },
      scope = {
         enabled = true,
         show_start = false,
         show_end = false,
         highlight = { "Function", "Label" }, -- tu peux custom les couleurs
      },
   },
}
