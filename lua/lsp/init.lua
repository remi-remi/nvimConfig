local lsps = {
	{ "dockerls", { cmd = { "docker-langserver", "--stdio" } } },
	{ "docker_compose_language_service", {} },
	{ "bashls", {} },
	{ "lua_ls", require("lsp.lua") },
	{ "cssls", require("lsp.css") },
	{ "eslint", require("lsp.eslint") },
	{ "vtsls", require("lsp.js") },
}

for _, lsp in ipairs(lsps) do
	local name, config = lsp[1], lsp[2]
	if config then
		vim.lsp.config(name, config)
	end
	vim.lsp.enable(name)
end

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		vim.notify("LSP started: " .. client.name, vim.log.levels.INFO)
	end,
})

-- to move to docker_compose_language_service latter
vim.filetype.add({
	filename = {
		["docker-compose.yml"] = "yaml.docker-compose",
		["docker-compose.yaml"] = "yaml.docker-compose",
		["compose.yml"] = "yaml.docker-compose",
		["compose.yaml"] = "yaml.docker-compose",
	},
})

-- when a file is directly open, .enable happen too late to detect the filetype
-- fixed by checking the filetype after configuration
vim.cmd("filetype detect")
