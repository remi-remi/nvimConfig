local M = {}

M.decide = function(export_path, exported_name)
   local file_name = vim.fn.fnamemodify(export_path, ":t:r")
   local ext = vim.fn.fnamemodify(export_path, ":e")
   local dir = vim.fn.fnamemodify(export_path, ":h")

   if file_name == exported_name then
      return {
         new_name = exported_name,
         new_path = export_path,
         rename_function = false,
         rename_file = false,
         cancelled = false,
      }
   end

   print("-- Mismatch detected:")
   print("i * File name       : " .. file_name)
   print("i * Exported name   : " .. exported_name)

   local choice = vim.fn.inputlist({
      "",
      "Renaming suggestion:",
      "1. Rename the function to " .. file_name .. " (file name)",
      "2. Rename the file to " .. exported_name .. " (function name)",
      "3. Enter name for booth",
      "4. Cancel (abort conversion)",
      "",
   })

   if choice == 0 then
      print("i * No choice made. stop. \n\n")
      return {
         new_name = exported_name,
         new_path = export_path,
         rename_function = false,
         rename_file = false,
         cancelled = true,
      }
   end

   if choice == 4 then
      return { cancelled = true }
   end

   local new_name = exported_name
   local rename_file = false
   local rename_function = false

   if choice == 1 then
      new_name = file_name
      rename_function = true
   elseif choice == 2 then
      new_name = exported_name
      rename_file = true
   elseif choice == 3 then
      new_name = vim.fn.input("Enter new name: ")
      print("\n")
      if new_name == "" then
         print(" ❌ No name entered. Aborting.")
         return { cancelled = true }
      end
      rename_file = true
      rename_function = true
   end

   local new_path = rename_file and (dir .. "/" .. new_name .. "." .. ext) or export_path

   return {
      new_name = new_name,
      new_path = new_path,
      rename_function = rename_function,
      rename_file = rename_file,
      cancelled = false,
   }
end

return M
