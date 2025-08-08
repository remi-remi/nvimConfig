local M = {}

M.rename = function(filepath, old_name, new_name)
   local lines = vim.fn.readfile(filepath)
   local modified = false
   local new_lines = {}

   local function line_has_comment_before(match_start, line)
      local comment_start = line:find("//")
      return comment_start and comment_start < match_start
   end

   for _, line in ipairs(lines) do
      local original_line = line

      -- Ignore comment lines
      local clean_line = line:gsub("//.*", "")

      -- Try patterns
      local replaced = clean_line
          :gsub("function%s+" .. old_name, "function " .. new_name)
          :gsub("const%s+" .. old_name .. "%s*=", "const " .. new_name .. " =")
          :gsub("let%s+" .. old_name .. "%s*=", "let " .. new_name .. " =")
          :gsub("var%s+" .. old_name .. "%s*=", "var " .. new_name .. " =")

      if replaced ~= clean_line then
         local match_start = clean_line:find(old_name, 1, true)
         if not line_has_comment_before(match_start, line) then
            table.insert(new_lines, replaced)
            modified = true
         else
            print(" ⚠️ Match found but ignored (commented line): " .. original_line)
            table.insert(new_lines, original_line)
         end
      else
         table.insert(new_lines, original_line)
      end
   end

   if modified then
      vim.fn.writefile(new_lines, filepath)
      print("! * Renamed function from '" .. old_name .. "' to '" .. new_name .. "'")
      return true
   else
      print(" ⚠️ No matching function declaration to rename found.")
      return false
   end
end

return M
