return {
	"MeanderingProgrammer/render-markdown.nvim",
	dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
	opts = {
		render_modes = { "n", "c" }, -- rendu en mode normal
		checkbox = { enabled = true },
		heading = { enabled = true },
		code = { enabled = true },
		table = { enabled = true },
		bullet = { enabled = false },
	},
}
