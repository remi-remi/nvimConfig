return {
   "stevearc/conform.nvim",
   event = "BufWritePre",
   config = function()
      require("conform").setup({
         formatters_by_ft = {
            javascript = { "prettier" },
            javascriptreact = { "prettier" },
            typescript = { "prettier" },
            typescriptreact = { "prettier" },
            css = { "prettier" },
            scss = { "prettier" },
            lua = { "stylua" },
         },
         format_on_save = {
            timeout_ms = 500,
            lsp_fallback = true,
         },
      })
   end,
}
