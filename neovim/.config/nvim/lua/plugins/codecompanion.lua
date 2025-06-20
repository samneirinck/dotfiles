local isWorkLaptop = require("config.utils").isWorkLaptop

return {
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "j-hui/fidget.nvim",
      'ravitemer/codecompanion-history.nvim',
    },
    config = true,
    opts = {
      adapters = {
        copilot = function()
          return require("codecompanion.adapters").extend("copilot", {
            schema = {
              model = isWorkLaptop() and { default = "claude-sonnet-4" } or {}
            }
          })
        end,
      },
      display = {
        action_palette = {
          provider = "telescope",
        },
        chat = {
          show_settings = false,
        }
      },
      extensions = {
        mcphub = {
          callback = "mcphub.extensions.codecompanion",
          opts = {
            show_result_in_chat = true, -- Show mcp tool results in chat
            make_vars = true,           -- Convert resources to #variables
            make_slash_commands = true, -- Add prompts as /slash commands
          }
        },
        vectorcode = {
          opts = {
            add_tool = true,
          }
        },
        history = {
          enabled = true,
          opts = {

          }
        }
      },
      strategies = {
        chat = {
          adapter = "copilot",
          roles = {
            llm = "🤖",
            user = "👤",
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
          },
          tools = {
            opts = {
              auto_submit_errors = true,
              auto_submit_success = true,
            }
          }
        },
        inline = {
          adapter = "copilot",
        }
      },
      prompt_library = {
        ['Diff code review'] = {
          strategy = 'chat',
          description = 'Perform a code review',
          opts = {
            auto_submit = true,
            user_prompt = false,
          },
          prompts = {
            {
              role = 'user',
              content = function()
                local target_branch = vim.fn.input('Target branch for merge base diff (default: master): ', 'master')

                return string.format(
                  [[
           You are a senior software engineer performing a code review. Analyze the following code changes.
           Identify any potential bugs, performance issues, security vulnerabilities, or areas that could be refactored for better readability or maintainability.
           Explain your reasoning clearly and provide specific suggestions for improvement.
           Consider edge cases, error handling, and adherence to best practices and coding standards.
           Here are the code changes:
           ```
            %s
           ```
           ]],
                  vim.fn.system('git diff --merge-base ' .. target_branch)
                )
              end,
            },
          },
        },
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
      },

    },
    keys = {
      { "<leader>ac", "<cmd>CodeCompanionChat<CR>",      desc = "AI - [C]hat",             mode = { "n", "v" } },
      { "<leader>aa", "<cmd>CodeCompanionActions<CR>",   desc = "AI - [A]ctions",          mode = { "n", "v" } },
      { "<leader>ai", "<cmd>CodeCompanion<CR>",          desc = "AI - [I]nline assistant", mode = { "n", "v" } },
      { "<leader>ax", "<cmd>CodeCompanion /explain<CR>", desc = "AI - E[x]plain",          mode = { "v" } },
      { "<leader>am", "<cmd>CodeCompanion /commit<CR>",  desc = "AI - Commit [M]essage",   mode = { "n" } },
    },
    init = function()
      require("plugins.codecompanion.fidget-spinner"):init()
    end
  }
}
