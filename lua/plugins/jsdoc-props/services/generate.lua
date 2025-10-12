-- services/generate.lua
-- Generates or updates a JSDoc block for component props (preserves inline comments).

local utils = require("plugins.jsdoc-props.utils.buffer")
local formatter = require("plugins.jsdoc-props.services.formatter")

local M = {}

---------------------------------------------------------------------
-- Helpers
---------------------------------------------------------------------

local function get_component_name(line)
   local name = line:match("([A-Z][%w_]*)%s*=")
   if not name then name = line:match("function%s+([A-Z][%w_]*)") end
   return name
end

-- Split a jsdoc into header / params / footer
local function parse_jsdoc_block(lines)
   local header, params, footer = {}, {}, {}
   local mode = "header"
   for _, l in ipairs(lines) do
      if l:match("^%s*%*%s*@param") then
         mode = "params"
         table.insert(params, l)
      elseif mode == "params" then
         table.insert(footer, l)
      else
         table.insert(header, l)
      end
   end
   return header, params, footer
end

-- Extract inner keys and trailing comment from grouped param
local function parse_grouped_param(line)
   local inner, trailing = line:match("{{(.-)}}(.*)")
   local names = {}
   if inner then
      for name in inner:gmatch("([%a_][%w_]*)%s*:") do
         table.insert(names, name)
      end
   end
   return names, (trailing and trailing:match("^%s*(.-)%s*$") or "")
end

-- Build updated jsdoc depending on style
local function build_updated_jsdoc(jsdoc_lines, props, component_name)
   local header, old_params, footer = parse_jsdoc_block(jsdoc_lines)

   local has_marker = false
   for _, l in ipairs(header) do
      if l:match("!%s*autoUpdate%s+" .. component_name) then
         has_marker = true
         break
      end
   end
   if not has_marker then
      table.insert(header, 2, " * ! autoUpdate " .. component_name .. " params !")
   end

   local result = {}
   local first_param_line = old_params[1] or ""

   if first_param_line:match("{{") then
      -------------------------------------------------------------------
      -- Grouped object-style param update  (preserve clean inline comment)
      -------------------------------------------------------------------
      local existing_names, trailing_comment = parse_grouped_param(first_param_line)

      -- remove repeated "props" tokens and excess spaces from trailing comment
      if trailing_comment ~= "" then
         trailing_comment = trailing_comment:gsub("%s*props%s*", "")
         trailing_comment = trailing_comment:gsub("%s+", " "):match("^%s*(.-)%s*$") or ""
      end

      local current_names = {}
      for _, p in ipairs(props) do
         current_names[p.name] = true
      end

      local merged = {}
      for _, name in ipairs(existing_names) do
         if current_names[name] then
            table.insert(merged, name .. ": any")
         end
      end
      for _, p in ipairs(props) do
         if not vim.tbl_contains(existing_names, p.name) then
            table.insert(merged, p.name .. ": any")
         end
      end

      local line = string.format(" * @param {{ %s }} props", table.concat(merged, ", "))
      if trailing_comment ~= "" then
         line = line .. "  " .. trailing_comment
      end
      table.insert(result, line)
   else
      -------------------------------------------------------------------
      -- Flat param update
      -------------------------------------------------------------------
      local existing = {}
      for _, line in ipairs(old_params) do
         local n, t, desc = line:match("@param%s+{([^}]+)}%s+([%w_]+)%s*(.*)")
         if n and t then existing[t] = { type = n, text = desc } end
      end

      for _, prop in ipairs(props) do
         local ex = existing[prop.name]
         local t = (ex and ex.type ~= "any") and ex.type or "any"
         local d = ex and ex.text or ""
         table.insert(result, string.format(" * @param {%s} %s%s", t, prop.name, (#d > 0 and " " .. d or "")))
      end
   end

   local cleaned_footer = {}
   for _, l in ipairs(footer) do
      if not l:match("^%s*%*/%s*$") then table.insert(cleaned_footer, l) end
   end

   local final_lines = {}
   vim.list_extend(final_lines, header)
   vim.list_extend(final_lines, result)
   vim.list_extend(final_lines, cleaned_footer)
   table.insert(final_lines, " */")

   return final_lines
end

---------------------------------------------------------------------
-- Main command
---------------------------------------------------------------------
function M.run()
   local bufnr = vim.api.nvim_get_current_buf()
   local cursor = vim.api.nvim_win_get_cursor(0)
   local current_line = cursor[1]
   local line = vim.api.nvim_get_current_line()

   local component_name = get_component_name(line)
   if not component_name then
      vim.notify("[jsdoc-props] No component name detected on this line.", vim.log.levels.WARN)
      return
   end

   local props = formatter.extract_props_from_line(line)
   if #props == 0 then
      vim.notify("[jsdoc-props] No props detected for " .. component_name, vim.log.levels.WARN)
      return
   end

   local jsdoc_start = utils.find_existing_jsdoc(current_line)
   if jsdoc_start then
      local block = utils.get_text_block(jsdoc_start, current_line - 1)
      local jsdoc_lines = type(block) == "string" and vim.split(block, "\n") or block
      local jsdoc_text = table.concat(jsdoc_lines, "\n")

      if not jsdoc_text:match("!%s*autoUpdate%s+" .. component_name) then
         vim.notify("[jsdoc-props] Existing JSDoc found but not owned (missing marker or wrong name).",
            vim.log.levels.ERROR)
         return
      end

      local updated = build_updated_jsdoc(jsdoc_lines, props, component_name)
      vim.api.nvim_buf_set_lines(bufnr, jsdoc_start - 1, current_line - 1, false, updated)
      vim.notify("[jsdoc-props] Updated JSDoc params for " .. component_name, vim.log.levels.INFO)
   else
      local jsdoc_lines = formatter.build_jsdoc(props)
      table.insert(jsdoc_lines, 2, " * ! autoUpdate " .. component_name .. " params !")
      vim.api.nvim_buf_set_lines(bufnr, current_line - 1, current_line - 1, false, jsdoc_lines)
      vim.notify("[jsdoc-props] Generated new JSDoc for " .. component_name, vim.log.levels.INFO)
   end
end

-- Support auto.lua (run for specific line)
function M.run_for_line(bufnr, line_nr)
   bufnr = bufnr or vim.api.nvim_get_current_buf()
   local line = vim.api.nvim_buf_get_lines(bufnr, line_nr - 1, line_nr, false)[1]
   if not line then return end

   local cursor_backup = vim.api.nvim_win_get_cursor(0)
   vim.api.nvim_win_set_cursor(0, { line_nr, 0 })
   local ok, err = pcall(M.run)
   vim.api.nvim_win_set_cursor(0, cursor_backup)
   if not ok then
      vim.notify("[jsdoc-props:auto] failed on line " .. line_nr .. ": " .. tostring(err), vim.log.levels.ERROR)
   end
end

return M
