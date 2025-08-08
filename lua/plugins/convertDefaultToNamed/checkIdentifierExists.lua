local M = {}

local declaration_patterns = {
   "const%s+%s*", "let%s+%s*", "var%s+%s*",
   "function%s+%s*", "class%s+%s*",
   "import%s+%s*", "export%s+%s*",
   "%s+label%s*:%s*", -- très rare mais valide
   "using%s+%s*", "with%s+%s*", "block%s+%s*",
}

M.check_if_identifier_exists = function(filepath, identifier, skip_import_path)
   local lines = vim.fn.readfile(filepath)
   local identifier_escaped = identifier:gsub("%W", "%%%0")

   for _, line in ipairs(lines) do
      local match_start = line:find(identifier, 1, true)
      local comment_start = line:find("//")
      if match_start and comment_start and comment_start < match_start then
         print("⚠️ IDENTIFIER : \"" .. identifier .. "\" exist in a comment from: " .. filepath .. " line: " .. line)
         goto continue
      end

      if skip_import_path and line:match("from%s+['\"]" .. skip_import_path .. "['\"]") then
         goto continue
      end

      for _, pattern in ipairs(declaration_patterns) do
         local full_pattern = pattern .. identifier_escaped
         if line:match(full_pattern) then
            return true
         end
      end

      ::continue::
   end

   return false
end

return M
