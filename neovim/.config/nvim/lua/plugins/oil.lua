return {
  {
    "stevearc/oil.nvim",
    ---@module "oil"
    ---@type oil.Config
    opts = {
      columns = {
        "icon",
      },
      view_options = {
        show_hidden = true,
      },
    },
    dependencies = { { "echasnovski/mini.icons", opts = {} } },
  }
}
