-- services/diagnostics.lua
-- Publish eslint-like diagnostics for JSDoc/props mismatch.

local M = {}
local utils = require("plugins.jsdoc-props.utils.buffer")
local formatter = require("plugins.jsdoc-props.services.formatter")

-- Persistent namespace
local ns = vim.api.nvim_create_namespace("jsdoc-props")

-- Detects likely React component declarations (single-line heuristic)
local function is_component_line(line)
   -- export ... TicketDisplay = (
   if line:match("[Ee]xport%s+[%w%s]*[A-Z][%w_]*%s*=") then return true end
   -- const TicketDisplay = (
   if line:match("[Cc]onst%s+[A-Z][%w_]*%s*=") then return true end
   -- function TicketDisplay(
   if line:match("^[%s]*[Ff]unction%s+[A-Z]") then return true end
   return false
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
               -- ensure jsdoc is directly above the function (within 10 lines)
               local jsdoc_text = utils.get_text_block(jsdoc_start, i - 1)
               local missing, extra = formatter.compare_props_with_jsdoc(props, jsdoc_text)

               ----------------------------------------------------------------
               -- (1) Check for marker mismatch
               ----------------------------------------------------------------
               local component_name = line:match("([A-Z][%w_]*)%s*=") or line:match("function%s+([A-Z][%w_]*)")
               if component_name then
                  local marker_name = jsdoc_text:match("!%s*autoUpdate%s+([A-Z][%w_]*)")
                  if marker_name and marker_name ~= component_name then
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
               -- (2) Normal JSDoc comparison logic
               ----------------------------------------------------------------
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

               ----------------------------------------------------------------
               -- (3) Detect typed params (non-any)
               ----------------------------------------------------------------
               local has_typed = false
               if type(jsdoc_text) == "string" then
                  for t in jsdoc_text:gmatch("@param%s+{([^}]+)}") do
                     if t and t ~= "any" then
                        has_typed = true
                        break
                     end
                  end
               end

               if has_typed then
                  table.insert(diagnostics, {
                     bufnr = bufnr,
                     lnum = jsdoc_start - 1,
                     col = 0,
                     message = "typed @param detected – type won't be auto-updated",
                     severity = vim.diagnostic.severity.HINT,
                     source = "jsdoc-props",
                  })
               end
            else
               -- JSDoc missing or too far away to belong to this component
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

   ----------------------------------------------------------------
   -- Apply diagnostics once
   ----------------------------------------------------------------
   vim.diagnostic.reset(ns, bufnr)
   if #diagnostics > 0 then
      vim.diagnostic.set(ns, bufnr, diagnostics)
   end
   -- print("[jsdoc-props] diagnostics set for buffer", bufnr, "#", #diagnostics)
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
