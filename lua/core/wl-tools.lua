local M = {}

-- Utility function to print a message in yellow
local function notify(msg)
  vim.api.nvim_echo({{msg, "WarningMsg"}}, false, {})
end

-- Command: Wlca - copy all file content to clipboard
function M.copy_file_to_clipboard()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local content = table.concat(lines, "\n")

  local handle = io.popen("wl-copy", "w")
  if handle then
    handle:write(content)
    handle:close()
    notify("File copied to clipboard")
  else
    notify("Failed to execute wl-copy")
  end
end

-- Command: Wlra - replace file content with clipboard
function M.replace_file_with_clipboard()
  local handle = io.popen("wl-paste", "r")
  if handle then
    local clipboard_content = handle:read("*a")
    handle:close()
    local lines = vim.split(clipboard_content, "\n", {plain=true})
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
    notify("File replaced by clipboard")
  else
    notify("Failed to execute wl-paste")
  end
end

  vim.api.nvim_create_user_command("Wlca", M.copy_file_to_clipboard, {desc = "Copy file content to clipboard"})
  vim.api.nvim_create_user_command("Wlra", M.replace_file_with_clipboard, {desc = "Replace file content with clipboard"})

return M

