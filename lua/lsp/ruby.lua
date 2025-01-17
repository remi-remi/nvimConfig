-- lsp/ruby.lua

local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local lsp = require('lsp')

-- Ruby
lspconfig.solargraph.setup {
  capabilities = lsp.capabilities,
  on_attach = lsp.on_attach,
}
