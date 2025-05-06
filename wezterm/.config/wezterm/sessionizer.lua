local wezterm = require("wezterm")
local mux = wezterm.mux
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
  fd = "/usr/bin/fd"
end

local has_value = function(tab, val)
  for _index, value in ipairs(tab) do
    if value == val then return true end
  end

  return false
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
  add_if_exists(args, os.getenv("HOME") .. "/Showpad/local-development/infrastructure")
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
          M.switch_workspace(id, label)
        end
      end),
      fuzzy = true,
      title = "Select project",
      choices = projects,
    }),
    pane
  )
end

M.switch_to_previous_workspace = function(window)
  local current_workspace = window:active_workspace()
  local workspace = wezterm.GLOBAL.previous_workspace

  if current_workspace == workspace or wezterm.GLOBAL.previous_workspace == nil then
    return
  end

  M.switch_workspace(workspace)
end

M.switch_workspace = function(workspace, cwd)
  current_workspace = mux.get_active_workspace()
  if current_workspace == workspace then
    return
  end

  wezterm.GLOBAL.previous_workspace = current_workspace

  if has_value(mux.get_workspace_names(), workspace) then
    mux.set_active_workspace(workspace)
    return
  end

  local tab, new_pane, window = mux.spawn_window { workspace = workspace, cwd = cwd }
  tab:set_title(workspace)


  local neovim, neovim_pane = window:spawn_tab {}
  neovim_pane:send_text("nvim .\n")
  neovim:set_title("neovim")

  local long = window:spawn_tab {}
  long:set_title("long-running")

  new_pane:activate()
  mux.set_active_workspace(workspace)
end

return M
