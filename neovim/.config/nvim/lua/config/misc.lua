-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "gitcommit",
  callback = function()
    -- Check if the commit message is empty (just comments or empty lines)
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local empty = true
    for _, line in ipairs(lines) do
      -- If line is not empty and not a comment, message is not empty
      if line:match("^[^#]") and line:match("%S") then
        empty = false
        break
      end
    end

    if empty then
      -- Get current branch name
      local branch = vim.fn.system("git branch --show-current"):gsub("\n", "")

      -- Extract JIRA ticket number (assuming format like "feature/ABC-123-description")
      local ticket = branch:match("[A-Z]+-[0-9]+")

      if ticket then
        -- Insert ticket at the beginning of the file
        vim.api.nvim_buf_set_lines(0, 0, 0, false, { ticket .. " " })
        -- Position cursor at end of inserted text
        vim.api.nvim_win_set_cursor(0, { 1, #ticket + 2 })
      end
    end
  end
})
