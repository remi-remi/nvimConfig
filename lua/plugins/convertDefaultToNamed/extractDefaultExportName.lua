local M = {}

M.get_exported_name = function(filepath)
   local content = table.concat(vim.fn.readfile(filepath), "\n")

   -- match: export default async function NAME(
   local name = content:match("export%s+default%s+async%s+function%s+([%w_]+)")
   if name then return name end

   -- match: export default function NAME(
   name = content:match("export%s+default%s+function%s+([%w_]+)")
   if name then return name end

   -- match: export default NAME;
   name = content:match("export%s+default%s+([%w_]+)%s*;?")
   if name then return name end

   return nil
end

return M
