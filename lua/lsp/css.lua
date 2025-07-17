local lspconfig = require("lspconfig")

lspconfig.cssls.setup({
   capabilities = require("cmp_nvim_lsp").default_capabilities(),
   settings = {
      css = {
         validate = true,
      },
      scss = {
         validate = true,
      },
      less = {
         validate = true,
      },
   },
})
