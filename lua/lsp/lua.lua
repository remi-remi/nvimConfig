-- lsp/lua.lua

local lspconfig = require('lspconfig')
local lsp = require('lsp')  -- Importer les paramètres LSP partagés

lspconfig.lua_ls.setup {
  capabilities = lsp.capabilities,
  on_attach = lsp.on_attach,
  settings = {
    Lua = {
      runtime = {
        -- Indique la version de Lua utilisée dans Neovim
        version = 'LuaJIT',
        -- Configure le chemin pour inclure les fichiers Lua
        path = vim.split(package.path, ';'),
      },
      diagnostics = {
        -- Reconnaît les variables globales de Neovim
        globals = { 'vim' },
      },
      workspace = {
        -- Rend le serveur conscient des fichiers runtime de Neovim
        library = vim.api.nvim_get_runtime_file('', true),
        checkThirdParty = false,  -- Évite les messages concernant les tiers
      },
      telemetry = {
        enable = false,  -- Désactive la télémétrie
      },
    },
  },
}

