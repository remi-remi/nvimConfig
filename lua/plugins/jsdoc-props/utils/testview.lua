-- utils/testview.lua
-- Opens a read-only scratch buffer with given lines.

local M = {}

function M.show(title, lines)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(buf, "modifiable", false)
  vim.api.nvim_buf_set_name(buf, title or "jsdoc-props: tests")
  vim.api.nvim_set_current_buf(buf)
end

return M
