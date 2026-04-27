return {
	"yousefhadder/markdown-plus.nvim",
	ft = "markdown",
	opts = {
		enabled = true,

		features = {
			list_management = true,
			text_formatting = true,
			thematic_break = true,
			links = true,
			images = true,
			headers_toc = true,
			quotes = true,
			callouts = true,
			code_block = true,
			html_block_awareness = true,
			table = true,
			footnotes = true,
		},

		keymaps = {
			enabled = true,
		},

		filetypes = { "markdown" },

		toc = {
			initial_depth = 2,
		},

		thematic_break = {
			style = "---", -- "---" | "***" | "___"
		},

		callouts = {
			default_type = "NOTE",
			custom_types = {},
		},

		code_block = {
			enabled = true,
			fence_style = "backtick", -- "backtick" | "tilde"
			languages = { "lua", "python", "javascript", "typescript", "bash", "json", "yaml", "markdown" },
		},

		table = {
			enabled = true,
			auto_format = true,
			default_alignment = "left",
			confirm_destructive = true,
			keymaps = {
				enabled = true,
				prefix = "<localleader>t",
				insert_mode_navigation = true,
			},
		},

		footnotes = {
			section_header = "Footnotes",
			confirm_delete = true,
		},

		list = {
			smart_outdent = true,
			checkbox_completion = {
				enabled = false,
				format = "emoji", -- "emoji" | "comment" | "dataview" | "parenthetical"
				date_format = "%Y-%m-%d",
				remove_on_uncheck = true,
				update_existing = true,
			},
		},

		links = {
			smart_paste = {
				enabled = false,
				timeout = 5, -- 1..30
			},
		},
	},
}
