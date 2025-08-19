-- Bootstrap Lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
   vim.fn.system({
      "git", "clone", "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", lazypath,
   })
end
vim.opt.rtp:prepend(lazypath)

-- Load plugins
require("lazy").setup({
   require("plugins.oneDark"),
   require("plugins.tokyonight"),
   require("plugins.nvim-web-devicons"),
   require("plugins.nvim-tree"),
   require("plugins.nvim-colorizer"),
   require("plugins.nvim-treesitter"),
   require("plugins.mason"),
   require("plugins.mason-lspconfig"),
   require("plugins.completion"),
   require("plugins.telescope"),
   require("plugins.lualine"),
   require("plugins.prettier"),
   require("plugins.vim-visual-multi"),
   require("plugins.precognition"),
})

require("plugins.convertDefaultToNamed")
