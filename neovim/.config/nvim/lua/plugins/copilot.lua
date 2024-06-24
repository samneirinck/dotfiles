return {
	-- Copilot
	{ 'github/copilot.vim' },

	-- Copilot chat
	{
		'CopilotC-Nvim/CopilotChat.nvim',
		branch = 'canary',
		dependencies = {
			{ 'github/copilot.vim' },
			{ "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
		},
		opts = {
			debug = false,
		}
	}
}
