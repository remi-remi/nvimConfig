-- Load plugins
require("plugins.init")

-- Load core settings
require("core.settings")
require("core.theme")
require("core.adoc-compile-on-save").setup()
require("core.diagnostic-config")
require("core.createDirOnSaveIfNotExist")
-- require("core.jsconfig-auto").ensure_jsconfig() -- if not simple node js stack, obsolete, may be removed, learn jsdoc is a better alternative
require("core.wl-tools")
require("core.wl-copy")
require("core.formatOnSave")

-- Load LSP
require("lsp.init")

-- Load grammar/language tools
-- require("lang.fr")

require("keymaps.init")
