return {
  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },

      -- Useful for getting pretty icons, but requires a Nerd Font.
      { 'nvim-tree/nvim-web-devicons',            enabled = vim.g.have_nerd_font },
    },
    config = function()
      -- Two important keymaps to use while in Telescope are
      --  - Insert mode: <c-/>
      --  - Normal mode: ?
      --
      -- This opens a window that shows you all of the keymaps for the current
      -- Telescope picker. This is really useful to discover what Telescope can
      -- do as well as how to actually do it!

      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      require('telescope').setup {
        defaults = {
          path_display = {
            "smart"
          },
          dynamic_preview_title = true,
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
          }
        },
        pickers = {
          find_files = {
            -- hidden = true,
            follow = true,
          },
          live_grep = {
            glob_pattern = "!package-lock.json",
            additional_args = { '--hidden' },
          },
        },
      }

      require('telescope').load_extension('fzf')

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'

      vim.keymap.set('n', '<leader>fa', builtin.find_files, { desc = '[F]ind [A]ll files' })
      vim.keymap.set('n', '<leader>ff', builtin.git_files, { desc = '[F]ind [F]iles' })
      vim.keymap.set('n', '<leader>f.', builtin.oldfiles, { desc = '[F]ind Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader>fd', builtin.lsp_document_symbols, { desc = '[F]ind [D]ocument Symbols' })

      vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = '[F]ind [H]elp' })
      vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = '[F]ind [K]eymaps' })
      vim.keymap.set('n', '<leader>fs', builtin.builtin, { desc = '[F]ind [S]elect Telescope' })
      vim.keymap.set('n', '<leader>fw', builtin.grep_string, { desc = '[F]ind current [W]ord' })
      -- vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = '[F]ind by [G]rep' })
      vim.keymap.set('n', '<leader>fr', builtin.resume, { desc = '[F]ind [R]esume' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set('n', '<leader>f/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[F]ind [/] in Open Files' })

      vim.keymap.set('n', '<leader>fn', function()
        builtin.find_files { cwd = vim.fn.stdpath('config') }
      end, { desc = '[F]ind [N]eovim files' })

      vim.keymap.set('n', '<leader>fp', function()
        builtin.find_files { cwd = vim.fs.joinpath(vim.fn.stdpath('data'), "lazy") }
      end, { desc = '[F]ind [P]lugins' })


      vim.keymap.set('n', '<leader>fg', function()
        local pickers = require("telescope.pickers")
        local finders = require("telescope.finders")
        local sorters = require("telescope.sorters")
        local make_entry = require("telescope.make_entry")
        local conf = require("telescope.config").values

        local opts = {}
        opts.cwd = vim.uv.cwd()

        local finder = finders.new_async_job {
          command_generator = function(prompt)
            if not prompt or prompt == "" then
              return nil
            end

            local args = { "rg", }
            local search_prompt = prompt
            for term in string.gmatch(prompt, "[^ ]+:[^ ]+") do
              local pieces = vim.split(term, ":")

              local keyword = pieces[1]
              local value = pieces[2]

              if keyword == "file" then
                table.insert(args, "--glob")
                table.insert(args, value)
              elseif keyword == "ext" then
                table.insert(args, "--glob")
                table.insert(args, "*." .. value)
              end

              local escaped_term = term:gsub("([^%w])", "%%%1")
              search_prompt = search_prompt:gsub("%s*" .. escaped_term .. "%s*", "")
            end

            table.insert(args, "-e")
            table.insert(args, search_prompt)

            ---@diagnostic disable-next-line: deprecated
            local cmd = vim.tbl_flatten {
              args,
              { "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case" }
            }

            return cmd
          end,
          entry_maker = make_entry.gen_from_vimgrep(opts),
          cmd = opts.cwd,
        }

        pickers.new(opts, {
          debounce = 100,
          prompt_title = "Live Grep",
          finder = finder,
          previewer = conf.grep_previewer(opts),
          sorter = sorters.empty(),
        }):find()
      end, { desc = '[F]ind [Y]Fancy' })
    end,
  },
}
-- Shortcut for searching your Neovim configuration files
