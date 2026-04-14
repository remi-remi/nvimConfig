return {
	"nvim-treesitter/nvim-treesitter",
	branch = "master",
	lazy = false,
	build = ":TSUpdate",
	-- Détection Arch Linux seulement
	config = function()
		local is_arch = vim.fn.executable("pacman") == 1
		local version = vim.version()
		local major, minor = version.major, version.minor

		-- Condition corrigée (> 0.11.x)
		if is_arch and (major > 0 or (major == 0 and minor > 11)) then
			vim.api.nvim_echo({
				{
					"⚠️  Neovim v" .. major .. "." .. minor .. "." .. version.patch .. " detected",
					"WarningMsg",
				},
				{ " → Downgrade to 0.11.6 required!", "ErrorMsg" },
				{ " (Arch ship tree-sitter with ABI-v14, nvim 0.12 needs ABIv15, breaking)", "Normal" },
				{ "\nPress [ENTER] to continue anyway or [q] to quit...", "Comment" },
			}, false, {}) -- false = pas history

			-- BLOQUE jusqu'à touche
			vim.fn.getchar()
			vim.cmd("redraw!") -- Nettoie écran
		end

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
