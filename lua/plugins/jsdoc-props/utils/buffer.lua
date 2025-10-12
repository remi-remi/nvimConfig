-- utils/buffer.lua
-- Fonctions utilitaires pour manipuler le buffer et afficher des logs.

local M = {}

function M.log(msg, level)
  vim.notify("[jsdoc-props] " .. msg, level or vim.log.levels.INFO)
end

function M.get_current_line_num()
  return vim.api.nvim_win_get_cursor(0)[1]
end

function M.get_line(n)
  return vim.api.nvim_buf_get_lines(0, n - 1, n, false)[1] or ""
end

function M.insert_lines(pos, lines)
  vim.api.nvim_buf_set_lines(0, pos - 1, pos - 1, false, lines)
end

function M.get_text_block(start_line, end_line)
  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  return table.concat(lines, "\n")
end

function M.find_existing_jsdoc(line_num)
  local lines = vim.api.nvim_buf_get_lines(0, 0, line_num - 1, false)
  for i = line_num - 1, 1, -1 do
    local l = lines[i]
    if l:match("^%s*/%*%*") then
      return i
    elseif not l:match("^%s*%*") and not l:match("^%s*/") then
      break
    end
  end
  return nil
end

return M
