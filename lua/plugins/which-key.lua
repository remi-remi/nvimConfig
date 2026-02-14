return {
   "folke/which-key.nvim",
   event = "VeryLazy",
   config = function()
      local wk = require("which-key")
      wk.setup({
         preset = "classic" -- classic,modern,helix
      })

      wk.add({
         { "<leader>l",   group = "LSP Saga" },

         { "<leader>lgd", "<cmd>Lspsaga goto_definition<CR>",         desc = "Go to Definition" },
         { "<leader>lpd", "<cmd>Lspsaga peek_definition<CR>",         desc = "Peek Definition" },
         { "<leader>lh",  "<cmd>Lspsaga hover_doc<CR>",               desc = "Hover Doc" },
         { "<leader>lf",  "<cmd>Lspsaga finder<CR>",                  desc = "Finder" },
         { "<leader>lr",  "<cmd>Lspsaga rename ++project<CR>",        desc = "Rename ++project" },
         { "<leader>la",  "<cmd>Lspsaga code_action<CR>",             desc = "Code Action" },
         { "<leader>lD",  "<cmd>Lspsaga show_line_diagnostics<CR>",   desc = "Line Diagnostics" },
         { "<leader>lc",  "<cmd>Lspsaga show_cursor_diagnostics<CR>", desc = "Cursor Diagnostics" },
         { "<leader>lo",  "<cmd>Lspsaga outline<CR>",                 desc = "Outline" },
         { "<leader>ln",  "<cmd>Lspsaga diagnostic_jump_next<CR>",    desc = "Next Diag" },
         { "<leader>lp",  "<cmd>Lspsaga diagnostic_jump_prev<CR>",    desc = "Prev Diag" },
      }, { prefix = "<leader>" })
   end,
}
