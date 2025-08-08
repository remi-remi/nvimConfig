local M = {}

-- Trouve tous les fichiers JS/JSX qui importent un fichier contenant `target_name` dans le chemin d'import
M.find_candidates = function(target_name)
   print("---- searching possible import of " .. target_name .. " using grep..")
   local cmd = string.format(
      "grep -rn --include=*.js --include=*.jsx 'from .*%s' .",
      target_name
   )

   local results = vim.fn.systemlist(cmd)
   local candidates = {}

   for _, line in ipairs(results) do
      local path, _, import_line = line:match("([^:]+):(%d+):(.*)")
      if path and import_line then
         local import_path = import_line:match("from%s+['\"](.+)['\"]")
         if import_path then
            print("importer found LINE:" .. import_line .. " PATH: " .. path)
            table.insert(candidates, {
               file = path,
               import_path = import_path,
               line = import_line,
            })
         end
      end
   end
   print("\n")
   return candidates
end

return M
