return {
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    dependencies = {
      'williamboman/mason.nvim',
      config = true
    },
    config = true,
    opts = {
      ensure_installed = {
        'gopls',
        'pyright',
        'phpactor',
        'typescript-language-server',
        'superhtml',
        'templ',
        'lua-language-server',
        'ruff'
      },
      auto_update = true,
    },
  }
}
