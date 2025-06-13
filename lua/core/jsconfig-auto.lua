local M = {}

local content = [[
{
  "compilerOptions": {
    "checkJs": true,
    "allowJs": true,
    "jsx": "react-jsx",
    "allowSyntheticDefaultImports": true,
    "baseUrl": ".",
    "paths": {
      "*": ["node_modules/*"]
    }
  },
  "include": ["src/**/*", "**/*.js", "**/*.jsx"],
  "exclude": ["node_modules"]
}
]]

M.ensure_jsconfig = function()
  local util = require("lspconfig.util")
  local root = util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", "node_modules")(vim.fn.expand("%:p"))
  if not root then return end

  local path = root .. "/jsconfig.json"
  if vim.fn.filereadable(path) == 1 then return end

  local prompt = "Create jsconfig.json at:\n" .. path .. " ? [y/N] "
  vim.fn.inputsave()
  local answer = vim.fn.input(prompt)
  vim.fn.inputrestore()

  if answer:lower() == "y" then
    local f = io.open(path, "w")
    if f then
      f:write(content)
      f:close()
      vim.notify("jsconfig.json created at: " .. path, vim.log.levels.INFO)
    end
  else
    vim.notify("jsconfig.json creation skipped", vim.log.levels.WARN)
  end
end

return M

