local lsps = {
   { "bashls", {} },
   { "lua_ls", require("lsp.lua") },
   { "cssls",  require("lsp.css") },
   { "eslint", require("lsp.eslint") },
   { "vtsls",  require("lsp.js") },
}

for _, lsp in ipairs(lsps) do
   local name, config = lsp[1], lsp[2]
   if config then
      vim.lsp.config(name, config)
   end
   vim.lsp.enable(name)
end
