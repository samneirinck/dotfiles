return {
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    dependencies = {
      'williamboman/mason.nvim',
      config = true,
      opts = {
        registries = {
          "github:mason-org/mason-registry",
          "github:Crashdummyy/mason-registry",
        },
      }
    },
    config = true,
    opts = {
      ensure_installed = {
        'gopls',
        'basedpyright',
        'phpactor',
        'typescript-language-server',
        'superhtml',
        'templ',
        'lua-language-server',
        'ruff',
        'roslyn',
        'eslint_d',
      },
      auto_update = true,
    },
  }
}
