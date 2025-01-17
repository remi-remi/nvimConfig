-- lsp/web_dev.lua

local lspconfig = require('lspconfig')
local lsp = require('lsp')  -- Import shared LSP configurations


local util = lspconfig.util

-- TypeScript/JavaScript
lspconfig.ts_ls.setup {
  capabilities = lsp.capabilities,
  on_attach = lsp.on_attach,
  init_options = {
    hostInfo = "neovim",
    -- Enable type checking for JavaScript files
    --implicitProjectConfig = {
    --  checkJs = true,
    --  strictNullChecks = true,
    --},
  },
  settings = {
    javascript = {
      inlayHints = {
        includeInlayVariableTypeHints = true,
      },
      format = {
        enable = true,
      },
   },
    typescript = {
      inlayHints = {
        includeInlayVariableTypeHints = true,
      },
      format = {
        enable = true,
      },
    },
  },
}


-- HTML
lspconfig.html.setup {
  capabilities = lsp.capabilities,
  on_attach = lsp.on_attach,
}

-- CSS
lspconfig.cssls.setup {
  capabilities = lsp.capabilities,
  on_attach = lsp.on_attach,
}

-- Emmet for JSX/HTML
lspconfig.emmet_ls.setup {
  capabilities = lsp.capabilities,
  on_attach = lsp.on_attach,
  filetypes = { 'html', 'css', 'javascriptreact', 'typescriptreact' },
}

