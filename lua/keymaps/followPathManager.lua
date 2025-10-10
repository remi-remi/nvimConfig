local path = require("helpers.pathResolver")

local M = {}

function M.smart_follow(opts)
   opts = opts or {}
   local open_in_tab = opts.tab or false
   local bufnr = vim.api.nvim_get_current_buf()

   local clients = vim.lsp.get_clients({ bufnr = bufnr })
   if #clients > 0 then
      local ok, telescope = pcall(require, "telescope.builtin")
      if ok then
         -- n'ouvre PAS de nouveau tab ici : ça casse l'attachement LSP
         telescope.lsp_definitions()

         -- si tu veux forcer l'ouverture dans un tab ensuite :
         if open_in_tab then
            vim.schedule(function()
               vim.cmd("tab split")
            end)
         end
         return
      else
         vim.notify("Telescope non disponible", vim.log.levels.WARN)
      end
   end

   -- fallback : aucun LSP attaché
   local filename = vim.fn.expand("<cfile>")
   local resolved = path.resolve_relative_path(filename)
   local cmd = open_in_tab and "tabnew" or "edit"
   vim.cmd(cmd .. " " .. resolved)
end

vim.keymap.set("n", "<A-f>", function() M.smart_follow({ tab = false }) end,
   { noremap = true, desc = "Follow symbol or path (LSP-aware)" })
vim.keymap.set("n", "<A-F>", function() M.smart_follow({ tab = true }) end,
   { noremap = true, desc = "Follow symbol or path in new tab (LSP-aware)" })

return M
