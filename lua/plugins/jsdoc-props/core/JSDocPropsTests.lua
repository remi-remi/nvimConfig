-- core/JSDocPropsTests.lua
-- Runs pure tests and shows results in a scratch buffer.

local M = {}

function M.setup()
  vim.api.nvim_create_user_command("JSDocPropsTests", function()
    require("plugins.jsdoc-props.tests").run_all()
  end, { desc = "Run jsdoc-props pure tests" })
end

return M
