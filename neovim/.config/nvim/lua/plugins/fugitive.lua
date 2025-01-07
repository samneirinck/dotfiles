return {
  {
    'tpope/vim-fugitive',
    keys = {
      { "<leader>gs", "<cmd>0Git<CR>",      desc = "Git Status" },
      { "<leader>gb", "<cmd>Git blame<CR>", desc = "Git Blame" },
    }
  },
  { 'shumphrey/fugitive-gitlab.vim' }
}
