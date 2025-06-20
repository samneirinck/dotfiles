local M = {}

function M.isWorkLaptop()
  local hostname = vim.loop.os_gethostname()
  return hostname ~= "desktop"
end

return M
