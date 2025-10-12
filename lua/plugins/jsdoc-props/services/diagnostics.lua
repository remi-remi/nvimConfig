-- services/diagnostics.lua
-- Publish eslint-like diagnostics for typedef-based JSDoc/props mismatch.

local M = {}
local utils = require("plugins.jsdoc-props.utils.buffer")
local formatter = require("plugins.jsdoc-props.services.formatter")

local ns = vim.api.nvim_create_namespace("jsdoc-props")

-- Detects likely React component declarations (single-line heuristic)
local function is_component_line(line)
   if line:match("[Ee]xport%s+[%w%s]*[A-Z][%w_]*%s*=") then return true end
   if line:match("[Cc]onst%s+[A-Z][%w_]*%s*=") then return true end
   if line:match("^[%s]*[Ff]unction%s+[A-Z]") then return true end
   return false
end

-- Extract property names from a typedef JSDoc text
local function extract_jsdoc_properties(text)
   local props = {}
   for name in text:gmatch("@property%s+{[^}]+}%s+([%w_]+)") do
      table.insert(props, name)
   end
   return props
end

-- Compare props from code vs JSDoc (@property)
local function compare_props(props, jsdoc_text)
   local js_props = extract_jsdoc_properties(jsdoc_text)
   local js_set, code_set = {}, {}
   for _, j in ipairs(js_props) do js_set[j] = true end
   for _, p in ipairs(props) do code_set[p.name] = true end

   local missing, extra = {}, {}
   for _, p in ipairs(props) do
      if not js_set[p.name] then table.insert(missing, p.name) end
   end
   for _, j in ipairs(js_props) do
      if not code_set[j] then table.insert(extra, j) end
   end
   return missing, extra
end

-- Build diagnostics for current buffer
function M.run(bufnr)
   bufnr = (bufnr ~= 0 and bufnr) or vim.api.nvim_get_current_buf()
   local diagnostics = {}

   local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
   for i, line in ipairs(lines) do
      if is_component_line(line) then
         local props = formatter.extract_props_from_line(line)
         if #props > 0 then
            local jsdoc_start = utils.find_existing_jsdoc(i)

            if jsdoc_start and (i - jsdoc_start) <= 10 then
               local jsdoc_text = utils.get_text_block(jsdoc_start, i - 1)
               local combined_text = jsdoc_text or ""

               -- look up a few lines above for another jsdoc block (typedef block)
               local search_start = jsdoc_start - 2
               while search_start > 1 do
                  local line_text = lines[search_start]
                  if line_text and line_text:match("^%s*/%*%*") then
                     local upper_block = utils.get_text_block(search_start, jsdoc_start - 1)
                     if upper_block and upper_block:match("@typedef%s+{Object}%s+[%w_]+") then
                        combined_text = upper_block .. "\n" .. (jsdoc_text or "")
                        break
                     end
                  elseif line_text and line_text:match("^%s*function") then
                     break -- stop if we hit another declaration
                  end
                  search_start = search_start - 1
               end

               local component_name = line:match("([A-Z][%w_]*)%s*=") or line:match("function%s+([A-Z][%w_]*)")


               ----------------------------------------------------------------
               -- (1) Check ownership marker
               ----------------------------------------------------------------
               if component_name then
                  local marker_name = jsdoc_text:match("!%s*autoUpdate%s+([A-Z][%w_]*)%s+params%s*!")
                  if not marker_name then
                     table.insert(diagnostics, {
                        bufnr = bufnr,
                        lnum = jsdoc_start - 1,
                        col = 0,
                        message = "JSDoc missing autoUpdate marker → run :GenerateJSDocProps",
                        severity = vim.diagnostic.severity.WARN,
                        source = "jsdoc-props",
                     })
                  elseif marker_name ~= component_name then
                     table.insert(diagnostics, {
                        bufnr = bufnr,
                        lnum = jsdoc_start - 1,
                        col = 0,
                        message = string.format(
                           "autoUpdate marker mismatch: '%s' ≠ '%s'  → edit or regenerate JSDoc",
                           marker_name, component_name
                        ),
                        severity = vim.diagnostic.severity.ERROR,
                        source = "jsdoc-props",
                     })
                  end
               end

               ----------------------------------------------------------------
               -- (2) Check for typedef consistency
               ----------------------------------------------------------------
               if jsdoc_text:match("@typedef%s+{Object}%s+[%w_]+") then
                  local missing, extra = formatter.compare_props_with_jsdoc(props, combined_text)

                  if (#missing > 0) or (#extra > 0) then
                     local parts = {}
                     if #missing > 0 then table.insert(parts, "missing: " .. table.concat(missing, ", ")) end
                     if #extra > 0 then table.insert(parts, "extra: " .. table.concat(extra, ", ")) end
                     table.insert(diagnostics, {
                        bufnr = bufnr,
                        lnum = i - 1,
                        col = 0,
                        message = "JSDoc mismatch → " .. table.concat(parts, " | ")
                            .. "  → run :GenerateJSDocProps to update",
                        severity = vim.diagnostic.severity.WARN,
                        source = "jsdoc-props",
                     })
                  else
                     table.insert(diagnostics, {
                        bufnr = bufnr,
                        lnum = i - 1,
                        col = 0,
                        message = "jsDoc ok",
                        severity = vim.diagnostic.severity.INFO,
                        source = "jsdoc-props",
                     })
                  end
               else
                  table.insert(diagnostics, {
                     bufnr = bufnr,
                     lnum = jsdoc_start - 1,
                     col = 0,
                     message = "JSDoc found but no typedef block detected",
                     severity = vim.diagnostic.severity.WARN,
                     source = "jsdoc-props",
                  })
               end
            else
               table.insert(diagnostics, {
                  bufnr = bufnr,
                  lnum = i - 1,
                  col = 0,
                  message = "Missing or misplaced JSDoc  → run :GenerateJSDocProps",
                  severity = vim.diagnostic.severity.WARN,
                  source = "jsdoc-props",
               })
            end
         end
      end
   end

   vim.diagnostic.reset(ns, bufnr)
   if #diagnostics > 0 then
      vim.diagnostic.set(ns, bufnr, diagnostics)
   end
end

-- Autocmd hooks
function M.setup_autocmds()
   vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost" }, {
      pattern = { "*.js", "*.jsx" },
      callback = function(args)
         pcall(M.run, args.buf)
      end,
   })
end

return M
