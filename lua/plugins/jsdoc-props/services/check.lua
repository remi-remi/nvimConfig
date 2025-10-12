-- services/check.lua
-- Compare les props destructurées et le bloc JSDoc existant.

local M = {}
local utils = require("plugins.jsdoc-props.utils.buffer")
local formatter = require("plugins.jsdoc-props.services.formatter")

function M.run()
  local line_num = utils.get_current_line_num()
  local line = utils.get_line(line_num)
  local props = formatter.extract_props_from_line(line)

  if #props == 0 then
    utils.log("Aucune prop détectée", vim.log.levels.WARN)
    return
  end

  local jsdoc_start = utils.find_existing_jsdoc(line_num)
  if not jsdoc_start then
    utils.log("Aucun bloc JSDoc trouvé", vim.log.levels.WARN)
    return
  end

  local jsdoc_text = utils.get_text_block(jsdoc_start, line_num - 1)
  local missing = formatter.compare_props_with_jsdoc(props, jsdoc_text)

  if #missing > 0 then
    utils.log("Props manquantes dans le JSDoc : " .. table.concat(missing, ", "), vim.log.levels.WARN)
  else
    utils.log("Bloc JSDoc à jour ✅", vim.log.levels.INFO)
  end
end

return M
