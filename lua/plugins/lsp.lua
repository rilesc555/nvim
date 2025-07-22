return {
  -- LSP Plugins
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  {
    'saecki/crates.nvim',
    tag = 'stable',
    ft = { 'toml' },
    config = function()
      require('crates').setup {
        lsp = {
          enabled = true,
          actions = true,
          completion = true,
          hover = true,
        },
      }
    end,
  },
  {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      -- Mason must be loaded before its dependents so we need to set it up here.ini
      'mason-org/mason.nvim',
      'mason-org/mason-lspconfig.nvim',

      -- Allows extra capabilities provided by nvim-cmp
      'saghen/blink.cmp',
    },
    config = function()
      --
      --  This function gets run when an LSP attaches to a particular buffer.
      --    That is to say, every time a new file is opened that is associated with
      --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
      --    function will be executed to configure the current buffer
      --
      -- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
      ---@param client vim.lsp.Client
      ---@param method vim.lsp.protocol.Method
      ---@param bufnr? integer some lsp support methods only in specific files
      ---@return boolean
      local function client_supports_method(client, method, bufnr)
        if vim.fn.has 'nvim-0.11' == 1 then
          return client:supports_method(method, bufnr)
        else
          return client.supports_method({ bufnr = bufnr }, method)
        end
      end

      -- Custom hover function that filters out problematic LSP clients
      local function smart_hover()
        -- Temporarily disable hover handlers for problematic clients
        local clients = vim.lsp.get_clients({ bufnr = 0 })
        local disabled_handlers = {}

        for _, client in ipairs(clients) do
          if client.name == 'ruff' or client.name == 'odools' or client.name == 'augment' then
            disabled_handlers[client.id] = client.handlers['textDocument/hover']
            client.handlers['textDocument/hover'] = function() end
          end
        end

        -- Call the standard hover function
        vim.lsp.buf.hover()

        -- Restore the original handlers after a short delay
        vim.defer_fn(function()
          for client_id, handler in pairs(disabled_handlers) do
            local client = vim.lsp.get_client_by_id(client_id)
            if client then
              client.handlers['textDocument/hover'] = handler
            end
          end
        end, 100)
      end

      -- setup lsp keymaps
      local function lsp_keymaps(bufnr)
        local map = function(keys, func, desc, mode)
          mode = mode or 'n'
          vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc })
        end

        map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
        map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
        map('gt', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
        map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
        map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
        map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
        map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
        map('K', smart_hover, 'Hover Documentation')
      end

      -- highlight references of the word under your cursor
      local function lsp_highlight_document(client, bufnr)
        if client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, bufnr) then
          local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = bufnr,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = bufnr,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })

          vim.api.nvim_create_autocmd('LspDetach', {
            group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
            end,
          })
        end
      end

      -- toggle inlay hints
      local function lsp_inlay_hints(client, bufnr)
        if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, bufnr) then
          vim.keymap.set('n', '<leader>ti', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = bufnr })
          end, { buffer = bufnr, desc = 'LSP: [T]oggle [I]nlay Hints' })
        end
      end

      -- on_attach function to run when LSP attaches to a buffer
      local on_attach = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if not client then
          return
        end

        lsp_keymaps(event.buf)
        lsp_highlight_document(client, event.buf)
        lsp_inlay_hints(client, event.buf)
        vim.lsp.log.set_format_func(vim.inspect)
      end

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = on_attach,
      })

      -- Change diagnostic symbols in the sign column (gutter)
      if vim.g.have_nerd_font then
        local signs = { ERROR = '', WARN = '', INFO = '', HINT = '' }
        local diagnostic_signs = {}
        for type, icon in pairs(signs) do
          diagnostic_signs[vim.diagnostic.severity[type]] = icon
        end
        vim.diagnostic.config { signs = { text = diagnostic_signs } }
      end

      local lspconfig = require 'lspconfig'

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add blink.cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with blink.cmp, and then broadcast that to the servers.
      local capabilities = require('blink.cmp').get_lsp_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, {
        general = {
          positionEncodings = { 'utf-16' },
        },
      })

      -- Set default capabilities for all LSP servers
      require('lspconfig').util.default_config = vim.tbl_deep_extend('force', require('lspconfig').util.default_config, { capabilities = capabilities })

      -- Enable LSP servers (configs are automatically loaded from lsp/ directory)
      vim.lsp.enable { 'rust-analyzer', 'bacon-ls', 'ruff', 'basedpyright', 'lua_ls' }
    end,
  },
}
