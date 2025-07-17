return {
  'Whenrow/odoo-ls.nvim',
  dependencies = { 'neovim/nvim-lspconfig' },
  config = function()
    local odools = require 'odools'
    local h = os.getenv 'HOME'
    odools.setup {
      -- mandatory
      odoo_path = h .. '/dev/odoo/odoo/',
      python_path = h .. '/.env/bin/python',

      -- optional
      addons = { h .. '/dev/odoo/odoo/addons' },
      settings = {
        autoRefresh = true,
        autoRefreshDelay = nil,
        diagMissingImportLevel = 'none',
      },
    }
  end,
}
