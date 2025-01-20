local utils = {}

utils.resolve_relative_path = function(relative_path)
    -- Récupère le chemin absolu du fichier actuellement ouvert
    local current_file_dir = vim.fn.expand('%:p:h')

    -- Combine le chemin courant avec le chemin relatif
    local combined_path = vim.fn.resolve(current_file_dir .. '/' .. relative_path)

    -- Convertit le chemin combiné en chemin absolu réel
    local absolute_path = vim.loop.fs_realpath(combined_path)

    return absolute_path or combined_path -- Retourne le chemin combiné si fs_realpath échoue
end

return utils

