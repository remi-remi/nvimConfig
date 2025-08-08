local pathResolver = require("plugins.convertDefaultToNamed.pathResolver")

local M = {}

M.filter_confirmed_candidates = function(candidates, export_path)
   local confirmed = {}
   print("--- accept/refuse candidates (check if they are real importation or false positive)")
   for _, item in ipairs(candidates) do
      -- print(string.format("→ %s imports via '%s'", item.file, item.import_path))

      local resolved_path = pathResolver.resolve_relative_to_base(item.file, item.import_path)
      -- print("resolved :", resolved_path)

      if resolved_path == export_path then
         print(" * checked, file:\"" .. item.file .. "\" realy import the file:\"" .. resolved_path .. "\"")
         table.insert(confirmed, item)
      else
         print(" * file: " ..
            item.file .. "does not import \"" .. export_path .. "\" in reality it import \"" .. resolved_path .. "\"")
      end
   end

   print("\n")

   return confirmed
end

return M
