return {
	{
		'vim-test/vim-test',
		enabled = false,
		config = function()
			vim.keymap.set("n", "<leader>tt", ":TestNearest<CR>", {})
			vim.keymap.set("n", "<leader>tT", ":TestFile<CR>", {})
			-- vim.keymap.set("n", "<leader>a", ":TestSuite<CR>", {})
			vim.keymap.set("n", "<leader>tl", ":TestLast<CR>", {})
			vim.keymap.set("n", "<leader>tg", ":TestVisit<CR>", {})
			vim.g['test#strategy'] = 'neovim'

			vim.g['test#php#phpunit#executable'] =
			'docker --log-level ERROR compose -f ../docker-compose.yml -f docker-compose.yml exec centralstation bin/phpunit --config app/phpunit.xml.dist'
		end,
	},
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
			"nvim-neotest/neotest-python",
			"olimorris/neotest-phpunit"
		},
		config = function()
			require("neotest").setup({
				adapters = {
					require("neotest-python"),
					require("neotest-phpunit") {
						phpunit_cmd = function()
							return {
								"docker",
								"--log-level", "ERROR",
								"compose",
								"-f", "../docker-compose.yml",
								"-f", "docker-compose.yml",
								"exec", "centralstation",
								"bin/phpunit",
								"--config", "app/phpunit.xml.dist"
							}
						end
					},
				}
			})
		end,
		keys = {
			{ "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Test file" },
			{ "<leader>tt", function() require("neotest").run.run() end,                   desc = "Test nearest" },
			{ "<leader>tl", function() require("neotest").run.run_last() end,              desc = "Test last" },
		},
	}
}
