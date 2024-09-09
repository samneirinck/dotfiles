return {
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {
      spec = {
        { '<leader>c', group = 'Code' },
        { '<leader>d', group = 'Document' },
        { '<leader>r', group = 'Rename' },
        { '<leader>s', group = 'Search' },
        { '<leader>w', group = 'Workspace' },
        { '<leader>t', group = 'Toggle' },
        { '<leader>h', group = 'Git Hunk' },
      },
    },
  },
}
