local wezterm = require("wezterm")
local act = wezterm.action

local M = {}

local function file_exists(path)
  local f = io.open(path, "r")
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

local function add_if_exists(t, path)
  if file_exists(path) then
    table.insert(t, path)
  end
end

local fd = "/opt/homebrew/bin/fd"
if not file_exists(fd) then
  fd = "/usr/local/bin/fd"
end

M.toggle = function(window, pane)
  local projects = {}

  local args = {
    fd,
    "-HI",
    "^.git$",
    "--no-ignore",
    "--max-depth=3",
    "--prune",
  }

  add_if_exists(args, os.getenv("HOME") .. "/Showpad")
  add_if_exists(args, os.getenv("HOME") .. "/Showpad/SBE")
  add_if_exists(args, os.getenv("HOME") .. "/Code/github.com")

  local success, stdout, stderr = wezterm.run_child_process(args)
  if not success then
    wezterm.log_error("Failed to run fd: " .. stderr)
    return
  end

  for line in stdout:gmatch("([^\n]*)\n?") do
    local project = line:gsub("/.git.*$", "")
    local label = project
    local id = project:gsub(".*/", "")
    table.insert(projects, { label = tostring(label), id = tostring(id) })
  end

  -- Showpad specific things
  if file_exists(os.getenv("HOME") .. "/Showpad") then
    table.insert(projects, { label = "staging", id = "staging" })
    table.insert(projects, { label = "production", id = "production" })
    table.insert(projects, { label = os.getenv("HOME") .. "/dotfiles", id = "dotfiles" })
  end

  window:perform_action(
    act.InputSelector({
      action = wezterm.action_callback(function(win, _, id, label)
        if not id and not label then
          wezterm.log_info("Cancelled")
        else
          wezterm.log_info("Selected " .. label)
          args = nil
          local current_workspace = window:active_workspace()
          win:perform_action(
            act.SwitchToWorkspace({ name = id, spawn = { args = args, cwd = label } }),
            pane
          )
          wezterm.GLOBAL.previous_workspace = current_workspace
        end
      end),
      fuzzy = true,
      title = "Select project",
      choices = projects,
    }),
    pane
  )
end

M.switch_to_previous_workspace = function(window, pane)
  local current_workspace = window:active_workspace()
  local workspace = wezterm.GLOBAL.previous_workspace

  if current_workspace == workspace or wezterm.GLOBAL.previous_workspace == nil then
    return
  end

  M.switch_workspace(window, pane, workspace)
end


return M
