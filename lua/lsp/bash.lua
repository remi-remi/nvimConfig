-- lsp/bash.lua

local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local lsp = require('lsp')

-- Bash
lspconfig.bashls.setup {
  capabilities = lsp.capabilities,
  on_attach = lsp.on_attach,
}

