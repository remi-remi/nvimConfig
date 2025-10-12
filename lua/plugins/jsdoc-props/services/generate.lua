-- services/generate.lua
-- Generates or updates a typedef-only JSDoc for React components,
-- plus a separate @type {React.FC<Props>} line for VTSLS JSX completion.

local utils = require("plugins.jsdoc-props.utils.buffer")
local formatter = require("plugins.jsdoc-props.services.formatter")

local M = {}

---------------------------------------------------------------------
-- Helpers
---------------------------------------------------------------------

local function get_component_name(line)
   local name = line:match("([A-Z][%w_]*)%s*=")
   if not name then
      name = line:match("function%s+([A-Z][%w_]*)")
   end
   -- new: support export function and React.memo
   if not name then
      name = line:match("export%s+function%s+([A-Z][%w_]*)")
   end
   if not name then
      name = line:match("React%.memo%s*%(%s*function%s*([A-Z][%w_]*)")
   end
   return name
end


-- Return a unique, stable-ordered list of prop tables {name=...}
local function unique_props(props)
   local seen, out = {}, {}
   for _, p in ipairs(props) do
      if p.name and not seen[p.name] then
         table.insert(out, { name = p.name })
         seen[p.name] = true
      end
   end
   return out
end

-- Parse existing typedef block to get current property names
local function parse_typedef_block(lines)
   local props = {}
   for _, l in ipairs(lines) do
      local nm = l:match("@property%s+{[^}]+}%s+([%w_]+)")
      if nm then table.insert(props, nm) end
   end
   return props
end

-- Build typedef JSDoc (marker + typedef + properties) — NO @type here
local function build_typedef_block(component_name, props)
   local typedef_name = component_name .. "Props"
   local lines = {}
   table.insert(lines, "/**")
   table.insert(lines, " * ! autoUpdate " .. component_name .. " params !")
   table.insert(lines, (" * @typedef {Object} %s"):format(typedef_name))
   for _, p in ipairs(props) do
      table.insert(lines, (" * @property {any} %s"):format(p.name))
   end
   table.insert(lines, " */")
   return lines
end

-- Build the separate @type {React.FC<Props>} annotation (one single-line block)
local function build_type_line(component_name)
   local typedef_name = component_name .. "Props"
   return { ("/** @type {React.FC<%s>} */"):format(typedef_name) }
end

-- Update an existing typedef block (rewrite entirely from fresh props)
local function update_typedef_block(jsdoc_lines, props, component_name)
   local merged = unique_props(props)
   return build_typedef_block(component_name, merged)
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
   props = unique_props(props)

   local jsdoc_start = utils.find_existing_jsdoc(current_line)
   if jsdoc_start then
      -- Update existing block (must be ours: marker + same component)
      local block = utils.get_text_block(jsdoc_start, current_line - 1)
      local jsdoc_lines = type(block) == "string" and vim.split(block, "\n") or block
      local jsdoc_text = table.concat(jsdoc_lines, "\n")

      if not jsdoc_text:match("!%s*autoUpdate%s+" .. component_name .. "%s+params%s*!") then
         vim.notify("[jsdoc-props] Existing JSDoc found but not owned (missing marker or wrong name).",
            vim.log.levels.ERROR)
         return
      end

      -- Rewrite typedef block
      local updated_typedef = update_typedef_block(jsdoc_lines, props, component_name)
      -- Commit updated typedef
      vim.api.nvim_buf_set_lines(bufnr, jsdoc_start - 1, current_line - 1, false, updated_typedef)

      -- Ensure the @type line exists just after the typedef block
      local type_line = build_type_line(component_name)
      -- Insert the @type line if the next non-empty line is not already an @type
      local after = jsdoc_start - 1 + #updated_typedef
      local next_line = vim.api.nvim_buf_get_lines(bufnr, after, after + 1, false)[1] or ""
      if not next_line:match("@type%s+{React%.FC<" .. component_name .. "Props>}") then
         vim.api.nvim_buf_set_lines(bufnr, after, after, false, type_line)
      end

      vim.notify("[jsdoc-props] Updated typedef for " .. component_name, vim.log.levels.INFO)
   else
      -- Fresh generation: typedef block then separate @type line
      local typedef_block = build_typedef_block(component_name, props)
      local type_line = build_type_line(component_name)
      local insertion = {}
      for _, l in ipairs(typedef_block) do table.insert(insertion, l) end
      for _, l in ipairs(type_line) do table.insert(insertion, l) end
      vim.api.nvim_buf_set_lines(bufnr, current_line - 1, current_line - 1, false, insertion)
      vim.notify("[jsdoc-props] Generated new typedef for " .. component_name, vim.log.levels.INFO)
   end
end

---------------------------------------------------------------------
-- Auto mode support
---------------------------------------------------------------------
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
