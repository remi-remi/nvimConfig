-- services/formatter.lua
-- Handles JSDoc parsing and comparison for typedef-based React component docs.

local parser = require("plugins.jsdoc-props.services.parser")

local M = {}

---------------------------------------------------------------------
-- Extract props from a component definition line
---------------------------------------------------------------------
function M.extract_props_from_line(line)
   local bufnr = vim.api.nvim_get_current_buf()
   local cursor = vim.api.nvim_win_get_cursor(0)
   local start_line = cursor[1]

   -- parser handles multiline and destructured params
   local parsed = parser.extract(line, bufnr, start_line)
   local props = {}
   for _, name in ipairs(parsed.names) do
      table.insert(props, { name = name, style = parsed.style })
   end
   return props
end

---------------------------------------------------------------------
-- Legacy builder (kept for compatibility, unused in typedef mode)
---------------------------------------------------------------------
function M.build_jsdoc(props)
   local lines = {}
   if #props == 0 then return lines end
   table.insert(lines, "/**")
   for _, p in ipairs(props) do
      table.insert(lines, string.format(" * @param {any} %s", p.name))
   end
   table.insert(lines, " */")
   return lines
end

---------------------------------------------------------------------
-- Compare props <-> jsdoc (typedef mode aware)
---------------------------------------------------------------------
function M.compare_props_with_jsdoc(props, jsdoc_text)
   local missing, extra = {}, {}
   local prop_names = {}

   -- props extracted from the component
   for _, p in ipairs(props) do
      prop_names[p.name] = true
   end

   -- Collect property names from typedef (new format)
   local jsdoc_props = {}
   for name in jsdoc_text:gmatch("@property%s+{[^}]+}%s+([%w_]+)") do
      table.insert(jsdoc_props, name)
   end

   -- If typedef contains nothing, fall back to old param-based parsing
   if #jsdoc_props == 0 then
      for name in jsdoc_text:gmatch("@param%s+{[^}]*}%s*([%w_]+)") do
         table.insert(jsdoc_props, name)
      end
   end

   local jsdoc_lookup = {}
   for _, n in ipairs(jsdoc_props) do jsdoc_lookup[n] = true end

   -- Missing in typedef
   for _, p in ipairs(props) do
      if not jsdoc_lookup[p.name] then
         table.insert(missing, p.name)
      end
   end

   -- Extra in typedef
   for _, n in ipairs(jsdoc_props) do
      if not prop_names[n] then
         table.insert(extra, n)
      end
   end

   return missing, extra
end

return M

