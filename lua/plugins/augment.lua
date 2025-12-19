return {
  'augmentcode/augment.vim',
  init = function()
    -- Disable default Tab mapping for Augment
    vim.g.augment_disable_tab_mapping = true

    -- Automatically add current working directory to Augment's workspace folders
    -- This allows Augment to index your project for better completions and chat
    vim.g.augment_workspace_folders = { vim.fn.getcwd() }
  end,
  config = function()
    -- Use Ctrl-Y to accept Augment AI suggestions
    vim.keymap.set('i', '<C-y>', '<cmd>call augment#Accept()<cr>', { silent = true, desc = 'Accept Augment AI completion' })

    -- Augment chat and completion keybindings (all start with <leader>a)
    vim.keymap.set('n', '<leader>am', '<cmd>Augment chat<cr>', { desc = '[A]ugment [M]essage' })
    vim.keymap.set('v', '<leader>am', ':Augment chat<cr>', { desc = '[A]ugment [M]essage with selection' })
    vim.keymap.set('n', '<leader>ac', '<cmd>Augment chat-toggle<cr>', { desc = '[A]ugment [C]hat toggle' })
    vim.keymap.set('n', '<leader>an', '<cmd>Augment chat-new<cr>', { desc = '[A]ugment [N]ew chat' })
    vim.keymap.set('n', '<leader>at', function()
      vim.g.augment_disable_completions = not vim.g.augment_disable_completions
      local status = vim.g.augment_disable_completions and 'disabled' or 'enabled'
      print('Augment completions ' .. status)
    end, { desc = '[A]ugment [T]oggle completions' })
  end,
}
