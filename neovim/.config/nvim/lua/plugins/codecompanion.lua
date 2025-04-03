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
        chat = {
          show_settings = true,
        }
      },
      strategies = {
        chat = {
          adapter = "copilot",
          roles = {
            llm = "🤖",
            user = "Sam"
          },
          slash_commands = {
            ["file"] = {
              opts = {
                provider = "telescope"
              }
            },
            ["buffer"] = {
              opts = {
                provider = "telescope"
              }
            },
            ["symbols"] = {
              opts = {
                provider = "telescope"
              }
            },
          }
        },
        inline = {
          adapter = "copilot",
        }
      },
      prompt_library = {
        ["Generate a Commit Message"] = {
          strategy = "inline",
          description = "Generate the commit message",
          opts = {
            placement = 'add',
            auto_submit = true,
          },
          prompts = {
            {
              role = "user",
              content = function()
                return string.format(
                  [[You are an expert at generating concise commit messages. Given the git diff listed below, please generate a commit message for me:

```diff
%s
```

When unsure about the module names to use in the commit message, you can refer to the last 20 commit messages in this repository:

```
%s
```

Current branch nane:
```
%s
```
If the branch name contains a JIRA ticket reference, prefix the message with the JIRA ticket reference.

A few examples:
- SP-1243 Fix issues with the login page
- SP-1244 Add a new feature to the dashboard

Output only the commit message without any explanations and follow-up suggestions.
]],
                  vim.fn.system('git diff --no-ext-diff --staged'),
                  vim.fn.system('git log --pretty=format:"%s" -n 20'),
                  vim.fn.system('git branch --show-current')
                )
              end,
              opts = {
                contains_code = true,
              },
            }
          }
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
