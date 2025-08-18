local detectOtherExports = require("plugins.convertDefaultToNamed.detectOtherExports")
local convertExport = require("plugins.convertDefaultToNamed.convertExportFileFromDefaultToNamed")
local updateNamedImports = require("plugins.convertDefaultToNamed.updateNamedImports")
local renamingManager = require("plugins.convertDefaultToNamed.renamingManager")
local extractExportName = require("plugins.convertDefaultToNamed.extractDefaultExportName")
local renameFunction = require("plugins.convertDefaultToNamed.renameFunctionInFile")
local renameUsage = require("plugins.convertDefaultToNamed.renameDefaultImportUsage")
local searchImportCandidate = require("plugins.convertDefaultToNamed.searchImportCandidate")
local confirmCandidates = require("plugins.convertDefaultToNamed.confirmCandidates")
local verifyImportIdentifiers = require("plugins.convertDefaultToNamed.verifyImportIdentifiers")

local M = {}

M.start = function()
   -- CONSTANTS (never reassigned)
   local original_export_path = vim.fn.expand("%:p")
   local original_filename = vim.fn.fnamemodify(original_export_path, ":t")
   local original_basename = vim.fn.fnamemodify(original_export_path, ":t:r")
   local original_ext = vim.fn.fnamemodify(original_export_path, ":e")

   print("---- Starting Default to Named Export Conversion ----")
   print(" * Export file     : " .. original_export_path)

   -- STEP 1: extract default exported symbol
   local original_export_name = extractExportName.get_exported_name(original_export_path)
   if not original_export_name then
      print(" ❌ No default export found.")
      print("---- Aborted ----")
      return
   end

   print(" * Exported symbol : " .. original_export_name)

   -- STEP 2: Abort if multiple exports
   if detectOtherExports.has_other_exports(original_export_path) then
      print(" ❌ Aborting: additional exports found.")
      print("---- Aborted ----")
      return
   end

   -- STEP 3: Handle name mismatch and ask for renaming if needed
   local rename_decision = nil
   if original_export_name ~= original_basename then
      print("⚠️  Exported name and file name mismatch.\n")
      rename_decision = renamingManager.decide(original_export_path, original_export_name)
      if rename_decision.cancelled then
         print(" ❌ Aborted by user.")
         print("---- Aborted ----")
         return
      end
   end

   -- FINAL TARGETS (may be renamed)
   local final_exported_name = rename_decision and rename_decision.new_name or original_export_name
   local final_export_path = rename_decision and rename_decision.new_path or original_export_path
   local actual_export_path = original_export_path

   -- STEP 4: Find possible import candidates
   local candidates = searchImportCandidate.find_candidates(original_filename)

   -- STEP 5: Confirm true imports
   local confirmed_candidates = confirmCandidates.filter_confirmed_candidates(candidates, original_export_path)

   -- STEP 6: Check if target name is already used
   if verifyImportIdentifiers.check_for_identifier_conflicts(confirmed_candidates, final_exported_name) then
      print(" ❌ Aborting: identifier already exists in one or more files.")
      print("---- Aborted ----")
      return
   end

   -- STEP 7: Rename function in export file if needed
   if rename_decision and rename_decision.rename_function then
      local renamed = renameFunction.rename(original_export_path, original_export_name, final_exported_name)
      if not renamed then
         print(" ❌ Aborting: function rename failed.")
         print("---- Aborted ----")
         return
      end
   end

   -- STEP 8: Convert export to named
   local success = convertExport.convert(original_export_path, original_export_name, final_exported_name)
   if not success then
      print(" ❌ Export conversion failed.")
      print("---- Aborted ----")
      return
   end

   -- STEP 9: Rename file if requested
   if rename_decision and rename_decision.rename_file then
      os.rename(original_export_path, final_export_path)
      actual_export_path = final_export_path
      print(" * File renamed to: " .. final_export_path)
   end

   -- STEP 10: Update imports across project
   updateNamedImports.update_all(confirmed_candidates, final_exported_name, original_export_path, final_export_path)

   -- STEP 11: Update usages of old default alias
   for _, candidate in ipairs(confirmed_candidates) do
      local old_alias = candidate.line:match("import%s+([%w_]+)%s+from")
      if old_alias and old_alias ~= final_exported_name then
         renameUsage.rename_usage(candidate.file, old_alias, final_exported_name, candidate.import_path)
      end
   end

   print("✅ Export converted and imports updated.")
   print("---- Conversion Completed ----")
end

vim.api.nvim_create_user_command('ConvertDefaultToNamed', function()
   require("plugins.convertDefaultToNamed").start()
end, {})

return M
