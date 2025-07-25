return {
	-- Highlight, edit, and navigate code
	'nvim-treesitter/nvim-treesitter',
	dependencies = {
		'nvim-treesitter/nvim-treesitter-textobjects',
		'OXY2DEV/markview.nvim',
	},
	build = ':TSUpdate',
	opts = {
		ensure_installed = { 'bash', 'diff', 'go', 'lua', 'python', 'html', 'markdown', 'vim', 'vimdoc', 'php', 'javascript', 'typescript', 'templ' },

		highlight = { enable = true },
		indent = { enable = true },
	},
	config = function(_, opts)
		require('nvim-treesitter.install').prefer_git = true
		require('nvim-treesitter.configs').setup(opts)
	end,
}
