local pathResolver = require("plugins.convertDefaultToNamed.pathResolver")

local M = {}

local function backup_file(filepath)
   local filename = vim.fn.fnamemodify(filepath, ":t")
   local ext = vim.fn.fnamemodify(filepath, ":e")
   local timestamp = os.time()
   local backup_dir = "/tmp/nvimConversion"

   vim.fn.mkdir(backup_dir, "p")

   local backup_path = string.format("%s/%s-%d.%s", backup_dir, filename, timestamp, ext)
   vim.fn.writefile(vim.fn.readfile(filepath), backup_path)
   print("📦 Backup saved for import file: " .. backup_path)
end

local function update_import_path(old_import_path, importer_file, old_export_path, new_export_path)
   print("update import path")
   print("importer_file used by path resolver : " .. importer_file .. " old_import_path : " .. old_import_path)

   local new_relative_path = pathResolver.relative_path(importer_file, new_export_path)
   print("! *  Updating import path from: '" .. old_import_path .. "' → '" .. new_relative_path .. "'")
   return new_relative_path
end

M.update_all = function(candidates, exported_name, old_export_path, new_export_path)
   print("-- Updating confirmed import statements to named imports")

   for _, item in ipairs(candidates) do
      local filepath = item.file
      local old_import_path = item.import_path
      local absolute_importer_path = vim.fn.fnamemodify(filepath, ":p")
      print("absolute_importer_path:" .. absolute_importer_path)
      local new_import_path = update_import_path(old_import_path, absolute_importer_path, old_export_path,
         new_export_path)
      local lines = vim.fn.readfile(filepath)
      local modified_lines = {}
      local changed = false

      for _, line in ipairs(lines) do
         if line:match("import%s+.+%s+from%s+['\"]" .. old_import_path .. "['\"]") then
            local import_path_to_use = new_import_path or old_import_path
            local new_line = "import { " .. exported_name .. " } from '" .. import_path_to_use .. "'"
            print("! * Rewriting import in " .. filepath .. ": " .. line .. " → " .. new_line)
            table.insert(modified_lines, new_line)
            changed = true
         else
            table.insert(modified_lines, line)
         end
      end

      if changed then
         backup_file(filepath)
         vim.fn.writefile(modified_lines, filepath)
         print("! File updated: " .. filepath)
      else
         print("⚠️ No matching import line found in: " .. filepath)
      end
   end

   print("\n")
end

return M
