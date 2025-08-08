local M = {}

M.has_other_exports = function(filepath)
   local lines = vim.fn.readfile(filepath)

   for _, line in ipairs(lines) do
      local clean = line:gsub("//.*", "") -- on ignore les commentaires simples
      if clean:match("export%s+") and not clean:match("export%s+default") then
         print("❌ Export additionnel trouvé : " .. line)
         return true
      end
   end

   return false
end

return M
