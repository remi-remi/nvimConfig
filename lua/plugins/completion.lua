return{
 'hrsh7th/nvim-cmp',
 dependencies = {
   'hrsh7th/cmp-nvim-lsp',
   'hrsh7th/cmp-buffer',
   'hrsh7th/cmp-path',
   'hrsh7th/cmp-cmdline',
 },
  config = function()
    require('cmp').setup(require('plugins.config.completion'))
  end,
}
