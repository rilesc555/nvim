return {
  'Whenrow/odoo-ls.nvim',
  dependencies = { 'neovim/nvim-lspconfig' },
  config = function()
    local odools = require('odools')
    local h = os.getenv('HOME')
    odools.setup({
      -- mandatory
      odoo_path = h .. '/Dev/odoo/src/odoo/',
      -- Find your python path by running `which python3` in your terminal.
      -- It should point to the python executable used for your Odoo project.
      python_path = '/usr/bin/python3', -- NOTE: Please update this path
      server_path = h .. '/.local/bin/odoo_ls_server',

      -- optional
      addons = { h .. '/Dev/odoo/src/odoo/addons', h .. '/Dev/odoo/src/enterprise/', h .. '/Dev/odoo/src/user/' },
      additional_stubs = { h .. '/Dev/odoo/src/typeshed/stubs' },
      root_dir = h .. '/Dev/odoo/src/', -- working directory, odoo_path if empty
      settings = {
        autoRefresh = true,
        autoRefreshDelay = nil,
        diagMissingImportLevel = 'none',
      },
    })
  end,
}
