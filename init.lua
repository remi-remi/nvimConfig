-- Supprime le warning "deprecated require('lspconfig')" jusqu'à la migration v3
local old_notify = vim.notify
vim.notify = function(msg, level, opts)
   if type(msg) == "string"
       and msg:match("The `require%('lspconfig'%)` \"framework\" is deprecated") then
      return
   end
   old_notify(msg, level, opts)
end


-- Load plugins
require("plugins.init")

-- Load core settings
require("core.settings")
require("core.theme")
require("core.adoc-compile-on-save").setup()
require("core.diagnostic-config")
require("core.createDirOnSaveIfNotExist")
require("core.jsconfig-auto").ensure_jsconfig()
require("core.wl-tools")
require("core.wl-copy")
require("core.formatOnSave")

-- Load LSP
require("lsp.init")

-- Load grammar/language tools
-- require("lang.fr")

require("keymaps.init")
