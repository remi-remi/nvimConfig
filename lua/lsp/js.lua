-- shared capabilities from cmp
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- shared on_attach
local function on_attach(client, bufnr)
   vim.notify("LSP attached: " .. client.name, vim.log.levels.INFO)

   local opts = { noremap = true, silent = true, buffer = bufnr }
   local map = vim.keymap.set

   map("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)
   map("n", "gr", "<cmd>Telescope lsp_references<CR>", opts)
   map("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)
   map("n", "<leader>rn", vim.lsp.buf.rename, opts)
   map("n", "<leader>ca", vim.lsp.buf.code_action, opts)
   map("n", "<leader>d", vim.diagnostic.open_float, opts)
   map("n", "[d", vim.diagnostic.goto_prev, opts) -- vim.diagnostic.goto_prev is deprecated
   map("n", "]d", vim.diagnostic.goto_next, opts)
   map("n", "<space>f", function() vim.lsp.buf.format({ async = true }) end, opts)
end

return {
   cmd = { "vtsls", "--stdio" },
   capabilities = capabilities,
   on_attach = on_attach,
   filetypes = {
      "javascript", "javascriptreact",
      "typescript", "typescriptreact",
   },

   settings = {
      typescript = {
         suggest = {
            autoImports = true,
         },
         preferences = {
            importModuleSpecifier = "auto",
            importModuleSpecifierEnding = "js",
            quoteStyle = "auto",
         },
      },
      javascript = {
         inlayHints = { parameterNames = { enabled = "all" } },
         format = {
            enable = true,
         },
         preferences = {
            importModuleSpecifier = "auto",
            importModuleSpecifierEnding = "js",
            quoteStyle = "auto",
         },
      },
   }
}
