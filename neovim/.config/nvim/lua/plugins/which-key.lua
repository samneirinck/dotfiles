return {
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {
      spec = {
        { '<leader>c', group = 'Code' },
        { '<leader>r', group = 'Rename' },
        { '<leader>f', group = 'Find' },
        { '<leader>w', group = 'Workspace' },
        { '<leader>t', group = 'Test' },
        { '<leader>h', group = 'Git Hunk' },
        { '<leader>a', group = 'AI' },
        { '<leader>g', group = 'Git' },
      },
    },
  },
}
