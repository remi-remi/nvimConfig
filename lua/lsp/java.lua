-- lsp/java.lua

local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local lsp = require('lsp')

-- Java
lspconfig.jdtls.setup {
  capabilities = lsp.capabilities,
  on_attach = lsp.on_attach,
  root_dir = lspconfig.util.root_pattern(".git", "mvnw", "gradlew", "pom.xml", "build.gradle"),
  cmd = { 'jdtls' },
}

