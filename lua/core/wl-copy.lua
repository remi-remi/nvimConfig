if not vim.g.neovide then
   vim.g.clipboard = {
      name = "wl-clipboard",
      copy = {
         ["+"] = "wl-copy --type text/plain",
         ["*"] = "wl-copy --type text/plain",
      },
      paste = {
         ["+"] = "wl-paste --no-newline",
         ["*"] = "wl-paste --no-newline",
      },
      cache_enabled = 1,
   }
end

if vim.g.neovide then
   vim.keymap.set({ "n", "i" }, "<C-S-v>", function()
      local clip = vim.fn.getreg("+")
      if vim.fn.mode() == "i" then
         vim.api.nvim_put({ clip }, "c", true, true)
      else
         vim.api.nvim_paste(clip, true, -1)
      end
   end, { noremap = true, silent = true, desc = "Paste from OS clipboard" })

   vim.keymap.set("v", "<C-S-c>", '"+y', { noremap = true, silent = true, desc = "Copy to OS clipboard" })

   vim.keymap.set("c", "<C-S-v>", "<C-R>+", { noremap = true, silent = false, desc = "Paste OS Clipboard in : mode" })
end
