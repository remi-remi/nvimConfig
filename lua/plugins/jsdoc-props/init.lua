-- jsdoc-props/init.lua
-- Plugin entry point: load core and background diagnostics.

local M = {}

local ok_core, core = pcall(require, "plugins.jsdoc-props.core")
if ok_core then
   M.core = core
else
   vim.notify("[jsdoc-props] failed to load core", vim.log.levels.ERROR)
end

-- Launch background diagnostics
local ok_diag, diag = pcall(require, "plugins.jsdoc-props.services.diagnostics")
if ok_diag then
   diag.setup_autocmds()
else
   vim.notify("[jsdoc-props] diagnostics unavailable", vim.log.levels.WARN)
end

return M
