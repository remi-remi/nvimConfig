return {
  "navarasu/onedark.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("onedark").setup {
      style = "cool", -- 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer', 'light'
    }
  end,
}

