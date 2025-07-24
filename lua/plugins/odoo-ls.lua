return {
  'Whenrow/odoo-ls.nvim',
  dependencies = { 'neovim/nvim-lspconfig' },
  ft = { 'python', 'xml', 'csv' },
  config = function()
    local h = os.getenv 'HOME'

    require('odools').setup {
      -- NOTE: Update these paths to match your system
      odoo_path = h .. '/dev_wsl/odoo/odoo/odoo',
      python_path = '/usr/bin/python3',
      -- addons_paths = { h .. '/dev_wsl/odoo/enterprise/odoo/addons', h .. '/dev_wsl/odoo/vertec_addons' },
      -- -- additional_stubs = { h .. '/dev/odoo/additional_stubs' },
      --
      -- -- Auto-install the language server if not found
      -- auto_install = true,
      --
      -- -- LSP settings
      -- settings = {
      --   Odoo = {
      --     autoRefresh = true,
      --     diagMissingImportLevel = 'none',
      --   },
      -- },
    }
  end,
}
