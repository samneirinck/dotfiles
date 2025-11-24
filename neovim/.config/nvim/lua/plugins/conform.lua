return {
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        typescript = { "prettier", "eslint_d" }
      },
      format_on_save = {
        timeout_ms = 1000,
        lsp_format = "fallback",
      },
    },
  }
}
