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
      opts = {
        system_prompt = function(opts)
          return
          [[You are a highly skilled software engineer with extensive knowledge in many programming languages, frameworks, design patterns, and best practices.

## Communication

1. Be conversational but professional. Be concise, direct, and to the point.
2. Refer to the user in the second person and yourself in the first person.
3. Format your responses in markdown. Use backticks to format file, directory, function, and class names.
4. NEVER lie or make things up.
5. Refrain from apologizing all the time when results are unexpected. Instead, just try your best to proceed or explain the circumstances to the user without apologizing.

IMPORTANT: You should minimize output tokens as much as possible while maintaining helpfulness, quality, and accuracy. Only address the specific query or task at hand, avoiding tangential information unless absolutely critical for completing the request. If you can answer in 1-3 sentences or a short paragraph, please do.
IMPORTANT: You should NOT answer with unnecessary preamble or postamble (such as explaining your code or summarizing your action), unless the user asks you to.
IMPORTANT: Keep your responses short, since they will be displayed on a command line interface. You MUST answer concisely with fewer than 4 lines (not including tool use or code generation), unless user asks for detail. Answer the user's question directly, without elaboration, explanation, or details. One word answers are best. Avoid introductions, conclusions, and explanations. You MUST avoid text before/after your response, such as \"The answer is <answer>.\", \"Here is the content of the file...\" or \"Based on the information provided, the answer is...\" or \"Here is what I will do next...\". Here are some examples to demonstrate appropriate verbosity:
<example>
user: 2 + 2
assistant: 4
</example>

<example>
user: what is 2+2?
assistant: 4
</example>

<example>
user: is 11 a prime number?
assistant: Yes
</example>

<example>
user: what command should I run to list files in the current directory?
assistant: ls
</example>
          ]]
        end,
      },
      adapters = {
        copilot = function()
          return require("codecompanion.adapters").extend("copilot", {
            schema = {
              model = {
                default = "claude-sonnet-4"
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
            grep = {
              description = "Seaches file contents using regular expressions",
              callback = {
                name = "grep",
                cmds = {
                  ---@param self CodeCompanion.Tool.Calculator The Calculator tool
                  ---@param args table The arguments from the LLM's tool call
                  ---@param input? any The output from the previous function call
                  ---@return nil|{ status: "success"|"error", data: string }
                  function(self, args, input)
                    local pattern = args.pattern
                    local path = args.path or "."
                    local include = args.operation or ""

                    vim.notify("Searcing for " .. pattern)

                    -- Use proper shell escaping for fish shell compatibility
                    local shell_cmd
                    if vim.o.shell:match("fish") then
                      -- Fish shell requires different escaping
                      shell_cmd = "rg --vimgrep --no-heading --color=never --hidden"
                      if include ~= "" then
                        shell_cmd = shell_cmd .. " --glob=" .. vim.fn.shellescape(include)
                      end
                      shell_cmd = shell_cmd .. " " .. vim.fn.shellescape(pattern) .. " " .. vim.fn.shellescape(path)
                    else
                      -- Standard shell escaping
                      shell_cmd = table.concat(cmd, " ")
                    end

                    local result = vim.fn.system(shell_cmd)

                    if vim.v.shell_error == 0 then
                      return { status = "success", data = result }
                    else
                      return { status = "error", data = "No matches found or error occurred: " .. result }
                    end
                  end
                },
                system_prompt = [[Fast content search tool that works with any codebase size
- Searches file contents using regular expressions
- Supports full regex syntax (eg. \"log.*Error\", \"function\\s+\\w+\", etc.)
- Filter files by pattern with the include parameter (eg. \"*.js\", \"*.{ts,tsx}\")
- Returns matching file paths sorted by modification time
- Use this tool when you need to find files containing specific patterns
]],

                schema = {
                  type = "function",
                  ["function"] = {
                    name = "grep",
                    description = "Seaches file contents using regular expressions",
                    parameters = {
                      type = "object",
                      properties = {
                        pattern = {
                          type = "string",
                          description = "The regular expression pattern to search for in file contents",
                        },
                        path = {
                          type = "string",
                          description = "The directory to search in. Defaults to the current working directory",
                        },
                        operation = {
                          type = "string",
                          description = "File pattern to include in the search (e.g. \"*.js\", \"*.{ts,tsx}\")",
                        },
                      },
                      required = {
                        "pattern"
                      },
                      additionalProperties = false,
                    },
                    strict = true,
                  },
                },
                handlers = {
                  ---@param self CodeCompanion.Tool.Calculator
                  ---@param agent CodeCompanion.Agent The tool object
                  setup = function(self, agent)
                    return vim.notify("setup function called", vim.log.levels.INFO)
                  end,
                  ---@param self CodeCompanion.Tool.Calculator
                  ---@param agent CodeCompanion.Agent
                  on_exit = function(self, agent)
                    return vim.notify("on_exit function called", vim.log.levels.INFO)
                  end,
                },
                output = {
                  ---@param self CodeCompanion.Tool.Calculator
                  ---@param agent CodeCompanion.Agent
                  ---@param cmd table The command that was executed
                  ---@param stdout table
                  success = function(self, agent, cmd, stdout)
                    local chat = agent.chat
                    return chat:add_tool_output(self, tostring(stdout[1]))
                  end,
                  ---@param self CodeCompanion.Tool.Calculator
                  ---@param agent CodeCompanion.Agent
                  ---@param cmd table
                  ---@param stderr table The error output from the command
                  ---@param stdout? table The output from the command
                  error = function(self, agent, cmd, stderr, stdout)
                    return vim.notify("An error occurred", vim.log.levels.ERROR)
                  end,
                },
              }
            },
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
