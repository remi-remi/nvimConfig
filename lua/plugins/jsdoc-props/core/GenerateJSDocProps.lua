-- core/generate.lua
-- Command entry for JSDoc generation

local M = {}
local gen = require("plugins.jsdoc-props.services.generate")

function M.setup()
  vim.api.nvim_create_user_command(
    "GenerateJSDocProps",
    gen.run,
    { desc = "Generate JSDoc block for destructured props" }
  )
end

return M
