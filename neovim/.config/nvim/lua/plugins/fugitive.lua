return {
  {
    'tpope/vim-fugitive',
    lazy = false,
    keys = {
      { "<leader>gs", "<cmd>0Git<CR>",      desc = "Git Status" },
      { "<leader>gb", "<cmd>Git blame<CR>", desc = "Git Blame" },
      { "<leader>gp", "<cmd>Git push<CR>",  desc = "Git Push" },
    }
  },
  { 'shumphrey/fugitive-gitlab.vim' }
}
