-- lsp/web_dev.lua

local lspconfig = require('lspconfig')
local cmp_nvim_lsp = require('cmp_nvim_lsp') -- Import pour améliorer les capacités LSP

-- Configuration des capacités pour autocomplétion
local capabilities = cmp_nvim_lsp.default_capabilities()

-- Raccourcis pour les LSP
local keymap = vim.keymap

-- Fonction on_attach pour configurer les raccourcis et les actions du LSP
local on_attach = function(client, bufnr)
  -- Message de confirmation pour chaque serveur attaché
  vim.notify("LSP started: " .. client.name, vim.log.levels.INFO)

  -- Raccourcis et autres configurations
  local opts = { noremap = true, silent = true, buffer = bufnr }
  local keymap = vim.keymap

  keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)
  keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", opts)
  keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)
  keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
  keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
  keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
  keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
  keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)

  keymap.set("n", "<space>f", function()
    vim.lsp.buf.format({ async = true })
  end, opts)
end


-- Configurer le serveur TypeScript/JavaScript
lspconfig.tsserver.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  filetypes = { 'javascript', 'javascriptreact' },
  root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", "jsconfig.json" , ".git"),
  settings = {
    javascript = {
      format = {
        enable = true,
      },
    },
    typescript = {
      format = {
        enable = true,
      },
    },
    tsserver = {
      compilerOptions = {
        jsx = "react-jsx",
        allowSyntheticDefaultImports = true,
      },
    },
  },
})

-- Configurer le serveur HTML
lspconfig.html.setup({
  capabilities = capabilities,
  on_attach = on_attach,
})

-- Configurer le serveur CSS
lspconfig.cssls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
})

-- Configurer le serveur Emmet uniquement pour HTML et CSS
lspconfig.emmet_ls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  filetypes = { 'html', 'css' },
})

-- Support explicite pour les fichiers .jsx
vim.filetype.add({
  extension = {
    jsx = "javascriptreact",
  },
})

-- Configurer les diagnostics globaux
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  update_in_insert = true,
  underline = true,
  severity_sort = true,
  float = {
    border = 'rounded',
  },
})

-- Activer les logs en mode debug
vim.lsp.set_log_level("debug")
vim.notify("LSP configuration loaded successfully!", vim.log.levels.INFO)

