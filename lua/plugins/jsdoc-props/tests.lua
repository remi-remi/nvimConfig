-- tests.lua
-- Pure tests for formatter; shows results in a scratch buffer and returns summary.

local fmt = require("plugins.jsdoc-props.services.formatter")
local view = require("plugins.jsdoc-props.utils.testview")

local T = {}

local results = {}

local function ok(name)
  table.insert(results, "✅ " .. name)
end

local function fail(name, msg)
  table.insert(results, "❌ " .. name .. (msg and (" — " .. msg) or ""))
end

local function linestr(lines)
  return table.concat(lines, "\n")
end

function T.test_destructured_with_default()
  local line = "export const C = ({ ticketId, isSelected, onSelectTicket='default' }) => {}"
  local props = fmt.extract_props_from_line(line)
  if #props ~= 3 then return fail("destructured_with_default", "wrong props count: " .. #props) end
  local jsdoc = linestr(fmt.build_jsdoc(props))
  if jsdoc:match("default: any") then return fail("destructured_with_default", "picked literal 'default'") end
  if not jsdoc:match("onSelectTicket%?: any") then return fail("destructured_with_default", "missing optional mark") end
  ok("destructured_with_default")
end

function T.test_multi_plain_with_default()
  local line = "export const C = (ticketId, isSelected, onSelectTicket='default') => {}"
  local props = fmt.extract_props_from_line(line)
  if #props ~= 3 then return fail("multi_plain_with_default", "wrong props count: " .. #props) end
  local jsdoc = linestr(fmt.build_jsdoc(props))
  if jsdoc:match("default") then return fail("multi_plain_with_default", "should not include literal default") end
  if not jsdoc:match("@param {any} ticketId") or not jsdoc:match("@param {any} isSelected") or not jsdoc:match("@param {any} onSelectTicket") then
    return fail("multi_plain_with_default", "missing @param lines")
  end
  ok("multi_plain_with_default")
end

function T.test_single_plain()
  local line = "export const C = (props) => {}"
  local props = fmt.extract_props_from_line(line)
  if #props ~= 1 then return fail("single_plain", "wrong props count: " .. #props) end
  local jsdoc = linestr(fmt.build_jsdoc(props))
  if not jsdoc:match("@param {any} props") and not jsdoc:match("@param {{ }} props") then
    return fail("single_plain", "expected @param {any} props")
  end
  ok("single_plain")
end

function T.test_compare_missing()
  local jsdoc_text = "/**\n * @param {{ ticketId: any }} props\n */"
  local props = {
    { name = "ticketId", style = "object" },
    { name = "isSelected", style = "object" },
  }
  local missing = fmt.compare_props_with_jsdoc(props, jsdoc_text)
  if not (missing[1] == "isSelected" and #missing == 1) then
    return fail("compare_missing", "expected only isSelected missing")
  end
  ok("compare_missing")
end

function T.run_all()
  results = {}
  local tests = 0
  for name, fn in pairs(T) do
    if name:match("^test_") then
      tests = tests + 1
      local ok_status, err = pcall(fn)
      if not ok_status then
        fail(name, err)
      end
    end
  end
  table.insert(results, 1, ("jsdoc-props tests (%d total):"):format(tests))
  view.show("jsdoc-props: tests", results)
  local failed = 0
  for _, line in ipairs(results) do
    if line:match("^❌") then failed = failed + 1 end
  end
  if failed > 0 then
    vim.notify(("[jsdoc-props] %d test(s) failed"):format(failed), vim.log.levels.ERROR)
  else
    vim.notify("[jsdoc-props] all tests passed", vim.log.levels.INFO)
  end
  return { total = tests, failed = failed, lines = results }
end

return T
