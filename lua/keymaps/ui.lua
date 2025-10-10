-- UI navigation (tabs, splits, etc.)
vim.keymap.set('n', '<C-A-Right>', ':tabnext<CR>', { noremap = true, silent = false })
vim.keymap.set('n', '<C-A-Left>', ':tabprevious<CR>', { noremap = true, silent = false })
vim.keymap.set('n', '<Leader>n', ':tabnew<CR>', { noremap = true, silent = true })

-- exit from terminal mode with the same behavior than any other modes
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { noremap = true, silent = true, desc = "Exit terminal mode" })



--
-- -- plugin from Noa ROW
-- local function arrow_msg(msg)
-- vim.notify(msg, vim.log.levels.WARN, { title = "No Arrows 🚫" })
-- end
--
-- vim.keymap.set({ "n", "v", "i" }, "<Up>", function()
-- arrow_msg("Use k for ↑")
-- end, { noremap = true, silent = true })
--
-- vim.keymap.set({ "n", "v", "i" }, "<Down>", function()
-- arrow_msg("Use j for ↓")
-- end, { noremap = true, silent = true })
--
-- vim.keymap.set({ "n", "v", "i" }, "<Left>", function()
-- arrow_msg("Use h for ←")
-- end, { noremap = true, silent = true })
--
-- vim.keymap.set({ "n", "v", "i" }, "<Right>", function()
-- arrow_msg("Use l for →")
-- end, { noremap = true, silent = true })
