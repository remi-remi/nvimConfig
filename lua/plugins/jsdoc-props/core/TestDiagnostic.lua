-- core/TestDiagnostic.lua
-- Provides :TestDiagnostic command for manual display test.

local M = {}

function M.setup()
  vim.api.nvim_create_user_command("TestDiagnostic", function()
    require("plugins.jsdoc-props.services.diagnostic_test").show_test_message()
  end, { desc = "Show test diagnostic on line 3" })
end

return M
