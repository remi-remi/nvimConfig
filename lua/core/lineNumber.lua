vim.opt.number = true
vim.opt.relativenumber = true

local numbertoggle = vim.api.nvim_create_augroup("numbertoggle", { clear = true })

vim.api.nvim_create_autocmd({ "InsertEnter" }, {
   group = numbertoggle,
   callback = function()
      vim.opt.relativenumber = false
   end,
})

vim.api.nvim_create_autocmd({ "InsertLeave" }, {
   group = numbertoggle,
   callback = function()
      vim.opt.relativenumber = true
   end,
})
