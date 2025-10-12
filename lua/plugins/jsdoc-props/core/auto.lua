-- core/auto.lua
-- Automatically update JSDoc blocks that opt in with "! autoUpdate <Name> params !"

local gen = require("plugins.jsdoc-props.services.generate")

local A = {}

local function is_component_line(line)
  return line:match("[Ee]xport%s+[%w%s]*[A-Z][%w_]*%s*=")
      or line:match("[Cc]onst%s+[A-Z][%w_]*%s*=")
      or line:match("^[%s]*[Ff]unction%s+[A-Z]")
end

local function has_autoupdate_marker(bufnr, lnum, name)
  local start = math.max(0, lnum - 10)
  local lines = vim.api.nvim_buf_get_lines(bufnr, start, lnum, false)
  local joined = table.concat(lines, "\n")
  return joined:match("!%s*autoUpdate%s+" .. name .. "%s+params%s*!") ~= nil
end

function A.run_auto(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  for i, line in ipairs(lines) do
    if is_component_line(line) then
      local name = line:match("([A-Z][%w_]*)%s*=") or line:match("function%s+([A-Z][%w_]*)")
      if name and has_autoupdate_marker(bufnr, i, name) then
        vim.schedule(function()
          gen.run_for_line(bufnr, i)
        end)
      end
    end
  end
end

function A.setup_autocmds()
  vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost" }, {
    pattern = { "*.js", "*.jsx" },
    callback = function(args)
      A.run_auto(args.buf)
    end,
  })
end

return A
