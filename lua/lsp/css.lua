return {
   cmd = { "vscode-css-language-server", "--stdio" },
   filetypes = { "css", "scss", "less" },
   capabilities = require("cmp_nvim_lsp").default_capabilities(),
   settings = {
      css = { validate = true },
      scss = { validate = true },
      less = { validate = true },
   },
}

