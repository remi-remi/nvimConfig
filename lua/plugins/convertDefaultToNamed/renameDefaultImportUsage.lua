local M = {}

M.rename_usage = function(filepath, old_name, new_name, import_path)
   local lines = vim.fn.readfile(filepath)
   local new_lines = {}
   local modified = false

   for _, line in ipairs(lines) do
      -- skip import line, we already modified it elsewhere
      if line:match("from%s+['\"]" .. import_path .. "['\"]") then
         table.insert(new_lines, line)
      else
         local replaced = line:gsub("(%W)" .. old_name .. "(%W)", "%1" .. new_name .. "%2")
         if replaced ~= line then
            modified = true
         end
         table.insert(new_lines, replaced)
      end
   end

   if modified then
      local timestamp = os.time()
      local backup_path = "/tmp/nvimConversion/" ..
          vim.fn.fnamemodify(filepath, ":t:r") .. "-" .. timestamp .. ".js"
      vim.fn.writefile(vim.fn.readfile(filepath), backup_path)
      print("📦 Backup saved before renaming usage: " .. backup_path)

      vim.fn.writefile(new_lines, filepath)
      print("🔁 Updated usage of '" .. old_name .. "' → '" .. new_name .. "' in " .. filepath)
   else
      print("ℹ️ No usage of '" .. old_name .. "' found in " .. filepath)
   end
end

return M
