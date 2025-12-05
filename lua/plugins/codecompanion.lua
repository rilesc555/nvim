return {
  "olimorris/codecompanion.nvim",
  tag = "v17.33.0",
  opts = {
    adapters = {
      acp = {
        gemini_cli = function()
          return require("codecompanion.adapters").extend("gemini_cli", {
            defaults = {
                ---@type string
                oauth_credentials_path = vim.fs.abspath("~/.gemini/oauth_creds.json"),
              },
              handlers = {
                auth = function(self)
                  ---@type string|nil
                  local oauth_credentials_path = self.defaults.oauth_credentials_path
                  return (oauth_credentials_path and vim.fn.filereadable(oauth_credentials_path)) == 1
                end,
              },
          })
        end,
      },
    },
    strategies = {
      chat = {
        adapter = "gemini_cli",
      },
      inline = {
        adapter = "gemini_cli",
      },
      cmd = {
        adapter = "gemini_cli",
      }
    }
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },

} 
