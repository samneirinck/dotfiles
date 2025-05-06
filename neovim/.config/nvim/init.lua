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
