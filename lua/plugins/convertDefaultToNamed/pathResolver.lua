local uv = vim.loop
local M = {}

local possible_extensions = { "", ".js", ".jsx", ".ts", ".tsx" }

M.resolve_relative_to_base = function(base_path, relative_path)
   local base_dir = vim.fn.fnamemodify(base_path, ":h")

   for _, ext in ipairs(possible_extensions) do
      local full_path = base_dir .. "/" .. relative_path .. ext
      local resolved = uv.fs_realpath(full_path)
      if resolved then
         return resolved
      end
   end

   -- fallback, non résolu
   return nil
end

M.relative_path = function(from, to)
   local function split(path)
      local parts = {}
      for part in path:gmatch("[^/]+") do
         table.insert(parts, part)
      end
      return parts
   end

   local from_parts = split(from)
   local to_parts = split(to)

   -- Remove common prefix
   while #from_parts > 0 and #to_parts > 0 and from_parts[1] == to_parts[1] do
      table.remove(from_parts, 1)
      table.remove(to_parts, 1)
   end

   local rel_parts = {}
   for _ = 1, #from_parts - 1 do
      table.insert(rel_parts, "..")
   end
   for _, part in ipairs(to_parts) do
      table.insert(rel_parts, part)
   end

   return "./" .. table.concat(rel_parts, "/")
end

return M
