local M = {}

local function backup_file(filepath)
   local filename = vim.fn.fnamemodify(filepath, ":t")
   local ext = vim.fn.fnamemodify(filepath, ":e")
   local timestamp = os.time()
   local backup_dir = "/tmp/nvimConversion"

   vim.fn.mkdir(backup_dir, "p")

   local backup_path = string.format("%s/%s-%d.%s", backup_dir, filename, timestamp, ext)
   vim.fn.writefile(vim.fn.readfile(filepath), backup_path)
   print(" * Backup saved to: " .. backup_path)
end

local function strip_inline_comment(line)
   return line:gsub("//.*", "")
end

M.convert = function(filepath, prev_exported_name, new_exported_name)
   print("--- Converting the export file from default to named " .. filepath .. " who export " .. prev_exported_name)
   local lines = vim.fn.readfile(filepath)
   backup_file(filepath)

   local modified = false
   local new_lines = {}

   local actual_exported_name

   if not new_exported_name then
      actual_exported_name = prev_exported_name
   else
      actual_exported_name = new_exported_name
   end

   for _, line in ipairs(lines) do
      local stripped = strip_inline_comment(line)
      -- print("→ looking for " .. actual_exported_name .. " in", stripped)
      -- Case 1: export default async function NAME(...)
      if stripped:match("export%s+default%s+async%s+function%s+" .. actual_exported_name) then
         local replaced = line:gsub(
            "export%s+default%s+async%s+function%s+" .. actual_exported_name,
            "export const " .. new_exported_name .. " = async function"
         )
         table.insert(new_lines, replaced)
         modified = true

         -- Case 2: export default function NAME(...)
      elseif stripped:match("export%s+default%s+function%s+" .. actual_exported_name) then
         local replaced = line:gsub(
            "export%s+default%s+function%s+" .. actual_exported_name,
            "export const " .. new_exported_name .. " = function"
         )
         table.insert(new_lines, replaced)
         modified = true

         -- Case 3: export default NAME;
      elseif stripped:match("export%s+default%s+" .. actual_exported_name .. "%s*;?") then
         local replaced = "export { " .. new_exported_name .. " }"
         table.insert(new_lines, replaced)
         modified = true
      else
         table.insert(new_lines, line)
      end
   end

   if modified then
      vim.fn.writefile(new_lines, filepath)
      print(" * Export default converted to named export")
      if vim.fn.expand("%:p") == filepath then
         vim.cmd("edit!")
      end
      print("-----")
      return true
   else
      print(" ❌ No convertible export default found, CHECK IT MANUALLY")
      print("-----")
      return false
   end
end


return M
