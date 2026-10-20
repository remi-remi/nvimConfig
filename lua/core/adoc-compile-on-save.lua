local M = {}

function M.compile_adoc()
   local file = vim.fn.expand("%:p")
   local dir = vim.fn.fnamemodify(file, ":h")
   local theme_used = vim.fn.filereadable(dir .. "/theme.yml") == 1

   local cmd = { "asciidoctor-pdf", "-a", "env-gem" }

   if vim.fn.isdirectory(dir .. "/fonts") == 1 then
      vim.list_extend(cmd, { "-a", "dir-fonts" })
   end

   if theme_used then
      vim.list_extend(cmd, { "-a", "pdf-themesdir=" .. dir, "-a", "pdf-theme=theme.yml" })
   end

   table.insert(cmd, file)

   vim.system(cmd, { text = true }, function(res)
      vim.schedule(function()
         if res.code == 0 then
            vim.notify(
               theme_used and "PDF compilation successful with custom theme!"
               or "PDF compilation successful without custom theme."
            )
         else
            vim.notify(
               ("Compilation failed (exit code %d):\n%s%s"):format(res.code, res.stdout or "", res.stderr or ""),
               vim.log.levels.ERROR
            )
         end
      end)
   end)
end

function M.setup()
   vim.api.nvim_create_autocmd("BufWritePost", {
      pattern = "*.adoc",
      callback = M.compile_adoc,
   })
end

return M
