-- Bootstrap Lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Load plugins
require("lazy").setup({
	require("plugins.indent-blankline"),
	require("plugins.oneDark"),
	require("plugins.cappucin"),
	require("plugins.tokyonight"),
	require("plugins.nvim-web-devicons"),
	require("plugins.nvim-tree"),
	require("plugins.nvim-colorizer"),
	require("plugins.treesitter"),
	require("plugins.mason"),
	require("plugins.completion"),
	require("plugins.telescope"),
	require("plugins.lualine"),
	require("plugins.conform"),
	require("plugins.vim-visual-multi"),
	require("plugins.precognition"),
	require("plugins.lua-snip"),
	require("plugins.lspsaga"),
	require("plugins.which-key"),
	require("plugins.lspconfig"),
	require("plugins.markdown-plus"),
	require("plugins.render-markdown"),
	require("plugins.vim-table-mode"),
	-- require("plugins.swapDiff"),
})

require("plugins.convertDefaultToNamed")
