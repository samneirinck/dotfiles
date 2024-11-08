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
		config = function(_, opts)
			local chat = require('CopilotChat')
			chat.setup(opts)

			vim.api.nvim_create_autocmd('BufEnter', {
				pattern = 'COMMIT_EDITMSG',
				callback = function()
					vim.wo.spell = true
					vim.api.nvim_win_set_cursor(0, { 1, 0 })
					if vim.fn.getline(1) == '' then
						vim.cmd 'startinsert!'
					end
				end,
			})
		end,
		opts = {
			model = 'claude-3.5-sonnet',
			question_header = '## 🧙 Sam ',
			answer_header = '## 🤖 Copilot ',
			error_header = '## 🚨 Error ',

		},
		keys = {
			{
				'<leader>aq',
				function()
					local input = vim.fn.input('Quick Chat: ')
					if input ~= '' then
						require('CopilotChat').ask(input,
							{ selection = require('CopilotChat.select').buffer })
					end
				end,
				desc = 'Quick Chat',
			},
			{ '<leader>ac', '<cmd>CopilotChatToggle<cr>',   desc = 'Toggle Chat' },
			{ '<leader>ae', '<cmd>CopilotChatExplain<cr>',  mode = { 'n', 'v' }, desc = 'Explain' },
			{ '<leader>ar', '<cmd>CopilotChatReview<cr>',   mode = { 'n', 'v' }, desc = 'Review' },
			{ '<leader>af', '<cmd>CopilotChatFix<cr>',      mode = { 'n', 'v' }, desc = 'Fix' },
			{ '<leader>ao', '<cmd>CopilotChatOptimize<cr>', mode = { 'n', 'v' }, desc = 'Optimize' },
			{ '<leader>ad', '<cmd>CopilotChatDocs<cr>',     mode = { 'n', 'v' }, desc = 'Docs' },
			{ '<leader>at', '<cmd>CopilotChatTests<cr>',    mode = { 'n', 'v' }, desc = 'Tests' },
			{ '<leader>am', '<cmd>CopilotChatCommitStaged<cr>',   mode = { 'n', 'v' }, desc = 'Commit' },
		},
	}
}
