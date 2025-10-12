-- services/formatter.lua
-- Uses parser.lua to format and compare JSDoc params.

local parser = require("plugins.jsdoc-props.services.parser")

local M = {}

---------------------------------------------------------------------
-- Extract props from a component definition line (with buffer context)
---------------------------------------------------------------------
function M.extract_props_from_line(line)
   local bufnr = vim.api.nvim_get_current_buf()
   local cursor = vim.api.nvim_win_get_cursor(0)
   local start_line = cursor[1]

   -- parser now knows how to look ahead for multiline params
   local parsed = parser.extract(line, bufnr, start_line)

   local props = {}
   for _, name in ipairs(parsed.names) do
      table.insert(props, { name = name, style = parsed.style })
   end
   return props
end

---------------------------------------------------------------------
-- Build a JSDoc block from extracted props
---------------------------------------------------------------------
function M.build_jsdoc(props)
   local lines = {}
   if #props == 0 then return lines end

   local style = props[1].style
   table.insert(lines, "/**")

   if style == "object" then
      -- grouped React-style props
      local parts = {}
      for _, p in ipairs(props) do table.insert(parts, p.name .. ": any") end
      table.insert(lines, " * @param {{ " .. table.concat(parts, ", ") .. " }} props")
   else
      -- flat params
      for _, p in ipairs(props) do
         table.insert(lines, string.format(" * @param {any} %s", p.name))
      end
   end

   table.insert(lines, " */")
   return lines
end

---------------------------------------------------------------------
-- Compare props <-> jsdoc: return missing and extra lists
---------------------------------------------------------------------
function M.compare_props_with_jsdoc(props, jsdoc_text)
   local missing, extra = {}, {}

   local prop_names = {}
   for _, p in ipairs(props) do prop_names[p.name] = true end

   for _, p in ipairs(props) do
      if not jsdoc_text:match("(%W)" .. p.name .. "(%W)") then
         table.insert(missing, p.name)
      end
   end

   for jsdoc_name in jsdoc_text:gmatch("@param%s+{[^}]*}%s*([%w_]+)") do
      if not prop_names[jsdoc_name] then
         table.insert(extra, jsdoc_name)
      end
   end

   return missing, extra
end

return M
