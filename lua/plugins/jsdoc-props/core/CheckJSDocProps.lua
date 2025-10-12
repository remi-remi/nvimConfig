-- core/check.lua
-- Command entry for JSDoc props consistency check

local M = {}
local check = require("plugins.jsdoc-props.services.check")

function M.setup()
  vim.api.nvim_create_user_command(
    "CheckJSDocProps",
    check.run,
    { desc = "Check JSDoc consistency with destructured props" }
  )
end

return M
