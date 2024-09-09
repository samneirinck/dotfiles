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
    -- config = function() -- This is the function that runs, AFTER loading
    --   -- local wk = require('which-key').setup()
    --   --
    --   -- -- Document existing key chains
    --   -- require('which-key').register {
    --   --   ['<leader>c'] = { group = '[C]ode' },
    --   -- }
    --   -- -- visual mode
    --   -- require('which-key').register({
    --   --   ['<leader>h'] = { 'Git [H]unk' },
    --   -- }, { mode = 'v' })
    -- end,
  },
}
