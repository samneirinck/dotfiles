local isWorkLaptop = require("config.utils").isWorkLaptop

return {
  "seblyng/roslyn.nvim",
  enabled = isWorkLaptop(),
  ---@module 'roslyn.config'
  ---@type RoslynNvimConfig
  opts = {
    -- your configuration comes here; leave empty for default settings
  },
}
