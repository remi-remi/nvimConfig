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
require("core.formatOnSave")

-- Load LSP
require("lsp.init")

-- Load grammar/language tools
-- require("lang.fr")

-- Theme (à activer après plugin tokyonight ou onedark)
-- vim.cmd("colorscheme onedark")

require("keymaps.init")
