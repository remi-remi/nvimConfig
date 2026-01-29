local util = vim.fs

return {
   filetypes = {
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
   },
   root_dir = function(fname)
      return util.root(fname, {
         "eslint.config.js",
         ".eslintrc",
         ".eslintrc.js",
         ".eslintrc.cjs",
         ".eslintrc.json",
         "package.json",
         ".git",
      })
   end,
   capabilities = require("cmp_nvim_lsp").default_capabilities(),
   on_attach = function(client, bufnr)
      if client.supports_method("textDocument/codeAction") then
         vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
               vim.lsp.buf.code_action({
                  context = { only = { "source.fixAll.eslint" } },
                  apply = true,
               })
            end,
         })
      end
   end,
}
