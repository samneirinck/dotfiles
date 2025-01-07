return {
	{
		'vim-test/vim-test',
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
}
