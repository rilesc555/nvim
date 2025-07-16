return {
  'augmentcode/augment.vim',
  event = 'VeryLazy',

  init = function()
    -- The following settings must be set before the plugin is loaded
    vim.g.augment_disable_tab_mapping = true
    vim.g.augment_workspace_folders = { vim.fn.getcwd() }
  end,

  keys = {
    { '<leader>am', ':Augment chat<CR>', desc = '[A] Send Message' },
    { '<leader>ac', ':Augment chat-toggle<CR>', desc = '[A]ugment [C]hat Toggle' },
    { '<leader>as', ':Augment status<CR>', desc = '[A]ugment [S]tatus' },
    { '<leader>an', ':Augment chat-new<CR>', desc = '[A]ugment [N]ew chat' },
    {
      '<C-y>',
      '<cmd>call augment#Accept()<cr>',
      mode = 'i',
      desc = 'Accept Augment completion',
    },
    {
      '<leader>at',
      function()
        if vim.g.augment_disable_completions == nil then
          vim.g.augment_disable_completions = false
        end
        vim.g.augment_disable_completions = not vim.g.augment_disable_completions
        if vim.g.augment_disable_completions then
          print 'Augment completions disabled'
        else
          print 'Augment completions enabled'
        end
      end,
      desc = '[A]ugment [T]oggle completions',
    },
  },
}
