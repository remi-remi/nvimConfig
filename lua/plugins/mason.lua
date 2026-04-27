return {
	"williamboman/mason.nvim",
	build = ":MasonUpdate",
	config = function()
		require("mason").setup()
		local ensure = {
			"vtsls",
			"bash-language-server",
			"css-lsp",
			"eslint-lsp",
			"lua-language-server",
			"docker-language-server",
			"docker-compose-language-service",
		}
		local registry = require("mason-registry")
		for _, name in ipairs(ensure) do
			local pkg = registry.get_package(name)
			if not pkg:is_installed() then
				pkg:install()
			end
		end
	end,
}
