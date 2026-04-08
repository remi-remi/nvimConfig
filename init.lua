require("core.settings")

-- Load plugins
require("plugins.init")

-- Load core settings
require("core.theme")
require("core.adoc-compile-on-save").setup()
require("core.diagnostic-config")
require("core.createDirOnSaveIfNotExist")
require("core.wl-tools")
require("core.wl-copy")
require("core.formatOnSave")
require("core.lineNumber")

-- Load LSP
require("lsp.init")

-- Load grammar/language tools
-- require("lang.fr")

require("keymaps.init")
