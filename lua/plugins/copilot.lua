return {
  'CopilotC-Nvim/CopilotChat.nvim',
  dependencies = {
    { 'github/copilot.vim' }, -- or zbirenbaum/copilot.lua
    { 'nvim-lua/plenary.nvim', branch = 'master' }, -- for curl, log and async functions
  },
  build = 'make tiktoken', -- Only on MacOS or Linux
  opts = {
    mappings = {
      accept_diff = {
        insert = '<Tab>',
        normal = '<Tab>', -- Accept the Copilot suggestion in normal mode
      },
    },
  },
  config = function(_, opts)
    require('CopilotChat').setup(opts)
    vim.g.copilot_no_tab_map = true
    vim.keymap.set('i', '<C-y>', 'copilot#Accept("\\<CR>")', {
      expr = true,
      replace_keycodes = false,
    })
  end,
  -- See Commands section for default commands if you want to lazy load on them
}
