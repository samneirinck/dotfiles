local wezterm = require 'wezterm'
local workspace_switcher = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")
local config = wezterm.config_builder()

config.color_scheme = "Catppuccin Mocha"

config.font = wezterm.font({ family = "MesloLGS Nerd Font Mono" })
config.font_size = 14

config.window_decorations = "RESIZE"
config.window_frame = {
  font = config.font
}
config.enable_wayland = false
config.hide_tab_bar_if_only_one_tab = true
config.window_padding = {
  left = 5,
  right = 5,
  top = 5,
  bottom = 0
}

config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
config.scrollback_lines = 10000

local function is_linux()
  return wezterm.target_triple:find('linux') ~= nil
end


local function resize_pane(key, direction)
  return {
    key = key,
    action = wezterm.action.AdjustPaneSize { direction, 3 }
  }
end

-- Use the defaults as a base
config.hyperlink_rules = wezterm.default_hyperlink_rules()

-- make task numbers clickable
table.insert(config.hyperlink_rules, {
  regex = [[\b(SP-\d+)\b]],
  format = 'https://showpad.atlassian.net/browse/$1',
})

-- smart splits
local function is_vim(pane)
  -- this is set by the plugin, and unset on ExitPre in Neovim
  return pane:get_user_vars().IS_NVIM == 'true'
end

local direction_keys = {
  h = 'Left',
  j = 'Down',
  k = 'Up',
  l = 'Right',
}

local function split_nav(resize_or_move, key)
  return {
    key = key,
    mods = resize_or_move == 'resize' and 'META' or 'CTRL',
    action = wezterm.action_callback(function(win, pane)
      if is_vim(pane) then
        -- pass the keys through to vim/nvim
        win:perform_action({
          SendKey = { key = key, mods = resize_or_move == 'resize' and 'META' or 'CTRL' },
        }, pane)
      else
        if resize_or_move == 'resize' then
          win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
        else
          win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
        end
      end
    end),
  }
end

config.keys = {
  {
    key = "|",
    mods = "LEADER|SHIFT",
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' }
  },
  {
    key = "\\",
    mods = "LEADER",
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' }
  },
  {
    key = "-",
    mods = "LEADER",
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' }
  },
  {
    key = 'm',
    mods = 'LEADER',
    action = wezterm.action.TogglePaneZoomState
  },
  {
    key = "q",
    mods = "LEADER",
    action = wezterm.action.ShowLauncherArgs { flags = "FUZZY|WORKSPACES", title = "Workspaces" }
  },
  {
    key = "s",
    mods = "LEADER",
    action = workspace_switcher.switch_workspace(),
  },
  {
    key = "a",
    mods = "LEADER",
    action = workspace_switcher.switch_to_prev_workspace(),
  },

  -- move between split panes
  split_nav('move', 'h'),
  split_nav('move', 'j'),
  split_nav('move', 'k'),
  split_nav('move', 'l'),
  -- resize panes
  split_nav('resize', 'h'),
  split_nav('resize', 'j'),
  split_nav('resize', 'k'),
  split_nav('resize', 'l'),
  {
    -- When we push LEADER + R...
    key = 'r',
    mods = 'LEADER',
    -- Activate the `resize_panes` keytable
    action = wezterm.action.ActivateKeyTable {
      name = 'resize_panes',
      -- Ensures the keytable stays active after it handles its
      -- first keypress.
      one_shot = false,
      -- Deactivate the keytable after a timeout.
      timeout_milliseconds = 1000,
    }
  },
}

wezterm.log_info("WezTerm configuration loaded")
if is_linux() then
  for i = 1, 9 do
    table.insert(config.keys, {
      key = tostring(i),
      mods = 'ALT',
      action = wezterm.action.ActivateTab(i - 1)
    })
  end
end

wezterm.on("smart_workspace_switcher.workspace_switcher.created", function(window, workspace)
  local shell_tab = window:active_tab()
  shell_tab:set_title("\u{e795} " .. (workspace:match("([^/\\]+)/?$") or workspace))

  local neovim, neovim_pane = window:spawn_tab {}
  neovim_pane:send_text("nvim\n")
  neovim:set_title("\u{f36f} neovim")

  local ai = window:spawn_tab {}
  ai:set_title("\u{f16a4} ai")

  local long = window:spawn_tab {}
  long:set_title("\u{f0f86} long-running")

  shell_tab:activate()
end)

config.key_tables = {
  resize_panes = {
    resize_pane('j', 'Down'),
    resize_pane('k', 'Up'),
    resize_pane('h', 'Left'),
    resize_pane('l', 'Right'),
  },
}


workspace_switcher.apply_to_config(config)

return config
