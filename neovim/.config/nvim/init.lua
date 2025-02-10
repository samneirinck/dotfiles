vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require 'config/options'
require 'config/keymaps'
require 'config/misc'

require 'lazy-bootstrap'
require 'lazy-plugins'

vim.api.nvim_create_user_command("Format", function()
	vim.lsp.buf.format()
end, {})
vim.api.nvim_create_user_command("FormatJson", '%!jq .', {})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "kotlin",
	callback = function(args)
		local coalesce_cmd =
		'/Users/sam.neirinck/Code/github.com/samneirinck/coalesce/build/install/coalesce/bin/coalesce'
		if vim.fn.executable(coalesce_cmd) == 1 then
			vim.lsp.start({
				name = "coalesce",
				cmd = { coalesce_cmd },
				cmd_env = {
					JAVA_OPTS =
					'-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:5005'
				},
				root_dir = vim.fs.root(args.buf, { 'build.gradle', 'build.gradle.kts' })
			})
		else
			vim.notify("Coalesce LSP command not found: " .. coalesce_cmd, vim.log.levels.WARN)
		end
	end
})
