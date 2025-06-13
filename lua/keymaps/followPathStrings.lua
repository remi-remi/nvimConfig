local path = require("helpers.pathResolver")

vim.keymap.set("n", "<A-f>", function()
  local filename = vim.fn.expand("<cfile>")
  local resolved = path.resolve_relative_path(filename)
  vim.cmd("edit " .. resolved)
end, { noremap = true, desc = "Follow path under cursor (open/create file)" })

vim.keymap.set("n", "<A-F>", function()
  local filename = vim.fn.expand("<cfile>")
  local resolved = path.resolve_relative_path(filename)
  vim.cmd("tabnew " .. resolved)
end, { noremap = true, desc = "Follow path under cursor+tabnew (open/create file)" })

