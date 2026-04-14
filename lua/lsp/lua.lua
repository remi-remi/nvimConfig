return {
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			diagnostics = { globals = { "vim" } },
			workspace = {
				library = { vim.env.VIMRUNTIME, "${3rd}/luv/library" },
				checkThirdParty = true,
			},
			telemetry = { enable = false },
		},
	},
}
