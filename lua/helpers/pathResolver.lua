local M = {}

local uv = vim.loop

-- Résout un chemin relatif depuis le fichier courant
M.resolve_relative_path = function(relative_path)
  local current_file_dir = vim.fn.expand('%:p:h')
  local combined_path = vim.fn.resolve(current_file_dir .. '/' .. relative_path)
  local absolute_path = uv.fs_realpath(combined_path)

  return absolute_path or combined_path
end

return M

