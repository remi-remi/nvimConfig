local M = {}

local uv = vim.loop

--- Résout un chemin relatif à partir d'un chemin de départ absolu
-- @param base_path string: le chemin absolu du fichier de départ (ex: /home/user/main.js)
-- @param relative_path string: le chemin relatif qu'on veut résoudre (ex: ./dir/file.js)
-- @return string|nil: chemin absolu résolu, ou nil si erreur
M.resolve_relative_to_base = function(base_path, relative_path)
   local base_dir = vim.fn.fnamemodify(base_path, ":h") -- répertoire du fichier base
   local combined_path = base_dir .. "/" .. relative_path
   local absolute_path = uv.fs_realpath(combined_path)
   return absolute_path or combined_path
end

return M
