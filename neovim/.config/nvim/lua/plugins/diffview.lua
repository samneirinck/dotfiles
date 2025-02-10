return {
  {
    "sindrets/diffview.nvim",
    opts = {

    },
    keys = {
      { "<leader>go", "<cmd>DiffviewOpen<CR>",        desc = "Open DiffView", mode = { "n" } },
      { "<leader>gh", "<cmd>DiffviewFileHistory<CR>", desc = "File history",  mode = { "n" } },
    },
  }
}
