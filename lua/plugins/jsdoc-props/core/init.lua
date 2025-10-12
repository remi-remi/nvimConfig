-- core/init.lua
-- Loads and initializes all command modules for jsdoc-props

local M = {}

local function safe_require(mod)
   local ok, module = pcall(require, "plugins.jsdoc-props.core." .. mod)
   if not ok then
      vim.notify("[jsdoc-props] failed to load core module: " .. mod, vim.log.levels.ERROR)
      return nil
   end
   return module
end

function M.setup_commands()
   local modules = { "GenerateJSDocProps", "CheckJSDocProps", "JSDocPropsTests", "TestDiagnostic" }

   for _, mod in ipairs(modules) do
      local m = safe_require(mod)
      if m and m.setup then m.setup() end
   end
end

local auto = require("plugins.jsdoc-props.core.auto")
auto.setup_autocmds()

M.setup_commands()
return M
