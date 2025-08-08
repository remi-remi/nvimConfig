local checkIdentifierExists = require("plugins.convertDefaultToNamed.checkIdentifierExists")

local M = {}

M.check_for_identifier_conflicts = function(candidates, exported_name)
   print("-- check if identifier \"" .. exported_name .. "\" exist in candidates")
   for _, item in ipairs(candidates) do
      local conflict = checkIdentifierExists.check_if_identifier_exists(item.file, exported_name, item.import_path)
      if conflict then
         print("❌ " ..
            item.file ..
            " ALREADY HAVE THE \"" .. exported_name .. "\", IDENTIFIER it may be unsafe to reafactor, cancel.")
         return true
      end
      print("no conflict found for " .. item.file)
   end
   print("\n")
   return false
end

return M
