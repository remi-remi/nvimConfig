-- services/diagnostic_test.lua
-- Injects a simple test diagnostic at line 3 of the active buffer.

local M = {}
local ns = vim.api.nvim_create_namespace("jsdoc-props-test")

function M.show_test_message()
  local bufnr = vim.api.nvim_get_current_buf()
  local diag = {
    {
      lnum = 2,  -- line 3 (0-indexed)
      col = 0,
      message = "🔧 jsdoc-props test diagnostic (line 3)",
      severity = vim.diagnostic.severity.WARN,
      source = "jsdoc-props-test",
    },
  }
  vim.diagnostic.reset(ns, bufnr)
  vim.diagnostic.set(ns, bufnr, diag)
  print("[jsdoc-props-test] inserted diagnostic on line 3 in buffer", bufnr)
end

return M
