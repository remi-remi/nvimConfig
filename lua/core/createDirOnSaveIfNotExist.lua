vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function(ctx)
    local dir = vim.fn.fnamemodify(ctx.file, ":h")
    if vim.fn.isdirectory(dir) == 0 then
      local prompt = "Directory does not exist: " .. dir .. ". Create it? [y/N] "
      vim.fn.inputsave()
      local answer = vim.fn.input(prompt)
      vim.fn.inputrestore()
      if answer:lower() == "y" then
        vim.fn.mkdir(dir, "p")
        vim.notify("Directory created: " .. dir, vim.log.levels.INFO)
      else
        vim.notify("Canceled save: directory missing", vim.log.levels.WARN)
        vim.cmd("abort")
      end
    end
  end,
})

