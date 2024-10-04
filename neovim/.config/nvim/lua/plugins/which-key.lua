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
        { '<leader>t', group = 'Toggle' },
        { '<leader>h', group = 'Git Hunk' },
      },
    },
  },
}
