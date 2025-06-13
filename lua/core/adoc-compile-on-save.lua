local M = {}

function M.compile_adoc()
  -- Récupère le chemin absolu du fichier adoc courant
  local file = vim.fn.expand("%:p")
  -- Construit le chemin absolu vers le fichier theme.yml situé dans le même répertoire que le fichier adoc
  local theme = vim.fn.fnamemodify(file, ':h') .. '/theme.yml'
  -- Construit la commande de compilation en utilisant le thème absolu
  local cmd = "asciidoctor-pdf -a pdf-theme=" .. theme .. " " .. file

  -- Tables pour capturer la sortie standard et d'erreur
  local stdout_lines = {}
  local stderr_lines = {}

  vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    stderr_buffered = true,
    on_stdout = function(_, data)
      if data then
        for _, line in ipairs(data) do
          if line ~= "" then
            table.insert(stdout_lines, line)
          end
        end
      end
    end,
    on_stderr = function(_, data)
      if data then
        for _, line in ipairs(data) do
          if line ~= "" then
            table.insert(stderr_lines, line)
          end
        end
      end
    end,
    on_exit = function(_, exit_code)
      if exit_code == 0 then
        vim.schedule(function()
          vim.notify("Compilation PDF réussie!", vim.log.levels.INFO)
        end)
      else
        local output = table.concat(stdout_lines, "\n") .. "\n" .. table.concat(stderr_lines, "\n")
        vim.schedule(function()
          vim.notify("Erreur lors de la compilation (code " .. exit_code .. "):\n" .. output, vim.log.levels.ERROR)
        end)
      end
    end,
  })
end

function M.setup()
  vim.cmd([[
    augroup AsciidocAutoCompile
      autocmd!
      autocmd BufWritePost *.adoc lua require('core.adoc-compile-on-save').compile_adoc()
    augroup END
  ]])
end

return M

