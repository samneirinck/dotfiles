---@type vim.lsp.Config
return {
	cmd = { 'basedpyright-langserver', '--stdio' },
	root_markers = { 'pyrightconfig.json', 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt' },
	filetypes = { 'python' },
	settings = {
		basedpyright = {
			analysis = {
				autoSearchPaths = true,
				useLibraryCodeForTypes = true,
				diagnosticMode = 'openFilesOnly',
			},
		},
	},
}
