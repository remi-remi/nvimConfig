local lspconfig = require("lspconfig")

lspconfig.eslint.setup({
   capabilities = require("cmp_nvim_lsp").default_capabilities(),
   on_attach = function(client, bufnr)
      -- Auto-fix on save
      vim.api.nvim_create_autocmd("BufWritePre", {
         buffer = bufnr,
         callback = function()
            vim.cmd("EslintFixAll") -- Built-in command provided by the eslint LSP
         end,
      })
   end,
   root_dir = lspconfig.util.root_pattern(
      ".eslintrc",
      ".eslintrc.json",
      ".eslintrc.js",
      "package.json",
      ".git"
   ),
})
