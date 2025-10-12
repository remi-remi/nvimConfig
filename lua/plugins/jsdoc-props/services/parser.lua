-- services/parser.lua
-- Extracts props from component definitions (supports destructured and flat styles).

local P = {}

-- utility: trim
local function trim(s)
   return s and s:match("^%s*(.-)%s*$") or ""
end

-- Parses a destructured parameter list like:
-- "({ a, b = 2, c })"  → { style="object", names={"a","b","c"}, defaults={b="2"} }
local function parse_object_params(segment)
   local names, defaults = {}, {}
   for entry in segment:gmatch("[^,]+") do
      local name, def = entry:match("^%s*([%a_][%w_]*)%s*=%s*([^,}]+)")
      if not name then
         name = entry:match("^%s*([%a_][%w_]*)")
      end
      if name then
         table.insert(names, trim(name))
         if def then defaults[trim(name)] = trim(def) end
      end
   end
   return { style = "object", names = names, defaults = defaults }
end

-- Parses flat parameters "(a, b=3, ...rest)"
local function parse_flat_params(segment)
   local names, defaults = {}, {}
   for entry in segment:gmatch("[^,]+") do
      local rest = entry:match("^%s*%.%.%.([%a_][%w_]*)")
      if rest then
         table.insert(names, trim(rest))
      else
         local name, def = entry:match("^%s*([%a_][%w_]*)%s*=%s*([^,]+)")
         if not name then name = entry:match("^%s*([%a_][%w_]*)") end
         if name then
            table.insert(names, trim(name))
            if def then defaults[trim(name)] = trim(def) end
         end
      end
   end
   return { style = "flat", names = names, defaults = defaults }
end

-- Main entry point
function P.extract(line, bufnr, start_line)
   bufnr = bufnr or vim.api.nvim_get_current_buf()
   start_line = start_line or 1

   -- Combine lines if parentheses not closed (handles multiline params)
   local combined = line
   local open_paren = select(2, line:gsub("%(", ""))
   local close_paren = select(2, line:gsub("%)", ""))

   if open_paren > close_paren then
      local lines = vim.api.nvim_buf_get_lines(bufnr, start_line, start_line + 10, false)
      for _, l in ipairs(lines) do
         combined = combined .. " " .. l
         local opens = select(2, l:gsub("%(", ""))
         local closes = select(2, l:gsub("%)", ""))
         open_paren = open_paren + opens
         close_paren = close_paren + closes
         if open_paren <= close_paren then
            break
         end
      end
   end

   ---------------------------------------------------------------------
   -- Detect destructured props first
   ---------------------------------------------------------------------
   local obj = combined:match("%(%s*{(.-)}%s*%)")
   if obj then
      return parse_object_params(obj)
   end

   ---------------------------------------------------------------------
   -- Then flat params
   ---------------------------------------------------------------------
   local seg = combined:match("%(([^{}]-)%)")
   if seg then
      return parse_flat_params(seg)
   end

   ---------------------------------------------------------------------
   -- Nothing found
   ---------------------------------------------------------------------
   return { style = "none", names = {}, defaults = {} }
end

return P
