return {
  'Whenrow/odoo-ls.nvim',
  ft = { 'python', 'xml', 'csv' },
  config = function()
    local h = os.getenv 'HOME'
    
    require('odoo-ls').setup {
      -- NOTE: Update these paths to match your system
      odoo_path = h .. '/dev/odoo/odoo/',
      python_path = h .. '/.pyenv/shims/python3',
      -- addons_paths = { h .. '/dev/odoo/enterprise' },
      -- additional_stubs = { h .. '/dev/odoo/additional_stubs' },
      
      -- Auto-install the language server if not found
      auto_install = true,
      
      -- LSP settings
      settings = {
        Odoo = {
          autoRefresh = true,
          diagMissingImportLevel = 'none',
        },
      },
    }
  end,
}
