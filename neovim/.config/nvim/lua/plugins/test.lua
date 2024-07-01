return {
	{
		'vim-test/vim-test',
		config = function()
				vim.keymap.set("n", "<leader>t", ":TestNearest<CR>", {})
				vim.keymap.set("n", "<leader>T", ":TestFile<CR>", {})
				vim.keymap.set("n", "<leader>a", ":TestSuite<CR>", {})
				vim.keymap.set("n", "<leader>l", ":TestLast<CR>", {})
				vim.keymap.set("n", "<leader>g", ":TestVisit<CR>", {})
				vim.g['test#strategy'] = 'neovim'

				vim.g['test#php#phpunit#executable'] = 'docker --log-level ERROR compose -f ../docker-compose.yml -f docker-compose.yml exec centralstation bin/phpunit --config app/phpunit.xml.dist'
		end,
	},
}
