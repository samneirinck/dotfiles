return {
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = true,
    opts = {
      adapters = {
        copilot = function()
          return require("codecompanion.adapters").extend("copilot", {
            schema = {
              model = {
                default = "claude-3.7-sonnet"
              }
            }
          })
        end,
      },
      display = {
        action_palette = {
          provider = "telescope",
        },
      },
      strategies = {
        chat = {
          adapter = "copilot",
        },
        inline = {
          adapter = "copilot",
        }
      }
    },
    keys = {
      { "<leader>ac", "<cmd>CodeCompanionChat<CR>",    desc = "AI - Chat",             mode = { "n", "v" } },
      { "<leader>aa", "<cmd>CodeCompanionActions<CR>", desc = "AI - Actions",          mode = { "n", "v" } },
      { "<leader>ai", "<cmd>CodeCompanion<CR>",        desc = "AI - Inline assistant", mode = { "n", "v" } },
    }
  }
}
