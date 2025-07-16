local M = {}

function M.compile_adoc()
  local file = vim.fn.expand("%:p")
  local basedir = vim.fn.fnamemodify(file, ':h')
  local theme = basedir .. '/theme.yml'
  local fonts = basedir .. '/fonts'

  -- Commence la commande avec les attributs nécessaires pour activer les blocs ifdef dans le .adoc
  local cmd = {
    "asciidoctor-pdf",
    "-a", "env-gem"
  }

  -- Ajoute -a dir-fonts seulement si le dossier fonts existe
  if vim.fn.isdirectory(fonts) == 1 then
    table.insert(cmd, "-a")
    table.insert(cmd, "dir-fonts")
  end

  -- Ajoute le thème
  if vim.fn.filereadable(theme) == 1 then
    table.insert(cmd, "-a")
    table.insert(cmd, "pdf-themesdir=" .. basedir)
    table.insert(cmd, "-a")
    table.insert(cmd, "pdf-theme=theme.yml")
  end

  -- Ajoute le fichier source
  table.insert(cmd, file)

  -- Convertit en chaîne
  local full_cmd = table.concat(cmd, " ")

  local stdout_lines = {}
  local stderr_lines = {}

  vim.fn.jobstart(full_cmd, {
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

