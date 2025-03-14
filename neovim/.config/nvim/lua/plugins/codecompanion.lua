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
      { "<leader>ac", "<cmd>CodeCompanionChat<CR>",      desc = "AI - [C]hat",             mode = { "n", "v" } },
      { "<leader>aa", "<cmd>CodeCompanionActions<CR>",   desc = "AI - [A]ctions",          mode = { "n", "v" } },
      { "<leader>ai", "<cmd>CodeCompanion<CR>",          desc = "AI - [I]nline assistant", mode = { "n", "v" } },
      { "<leader>ax", "<cmd>CodeCompanion /explain<CR>", desc = "AI - E[x]plain",          mode = { "v" } },
      { "<leader>am", "<cmd>CodeCompanion /commit<CR>",  desc = "AI - Commit [M]essage",   mode = { "n" } },
    }
  }
}
