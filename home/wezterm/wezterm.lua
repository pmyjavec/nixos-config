local wezterm = require 'wezterm'
local act = wezterm.action
local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- Beautiful macOS styling
config.audible_bell = 'Disabled'
config.color_scheme = 'Tokyo Night Storm'
config.enable_scroll_bar = false
config.enable_wayland = false
config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = false
config.show_new_tab_button_in_tab_bar = false
config.show_tab_index_in_tab_bar = false
config.tab_and_split_indices_are_zero_based = false
config.tab_max_width = 32
config.hide_tab_bar_if_only_one_tab = false
config.window_frame = {
  font = wezterm.font { family = 'FiraCode Nerd Font Mono', weight = 'Bold' },
  font_size = 12.0,
}

-- Font configuration with better rendering
config.font = wezterm.font_with_fallback({
  'FiraCode Nerd Font Mono',
  'Menlo',
  'Monaco',
  'SF Mono',
})
config.font_size = 14.0
config.line_height = 1.2
config.freetype_load_flags = 'NO_HINTING'
config.freetype_render_target = 'HorizontalLcd'

-- Window appearance
config.window_decorations = 'INTEGRATED_BUTTONS|RESIZE'
config.window_background_opacity = 0.92
config.macos_window_background_blur = 30
config.text_background_opacity = 0.8
config.initial_cols = 120
config.initial_rows = 30

-- Make window start at 80% of screen size
wezterm.on('gui-startup', function()
  local tab, pane, window = wezterm.mux.spawn_window{}
  local gui_win = window:gui_window()
  local screen = wezterm.gui.screens().active
  gui_win:set_position(screen.width * 0.1, screen.height * 0.1)
  gui_win:set_inner_size(screen.width * 0.8, screen.height * 0.8)
end)
config.window_padding = {
  left = 20,
  right = 20,
  top = 40,
  bottom = 20,
}

-- Cursor styling
config.default_cursor_style = 'BlinkingBar'
config.cursor_blink_rate = 500
config.cursor_blink_ease_in = 'Constant'
config.cursor_blink_ease_out = 'Constant'

-- Behavior
config.hide_mouse_cursor_when_typing = true
config.pane_focus_follows_mouse = true
config.scrollback_lines = 50000
config.use_ime = false
config.debug_key_events = false
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = false

-- Inactive pane styling
config.inactive_pane_hsb = {
  saturation = 0.8,
  brightness = 0.7,
}

-- Visual bell with smooth animation
config.visual_bell = {
  fade_in_function = 'EaseIn',
  fade_in_duration_ms = 150,
  fade_out_function = 'EaseOut',
  fade_out_duration_ms = 150,
}

-- Enhanced color palette
config.colors = {
  visual_bell = '#1a1b26',
  foreground = '#c0caf5',
  background = '#1a1b26',
  
  cursor_bg = '#c0caf5',
  cursor_fg = '#1a1b26',
  cursor_border = '#c0caf5',
  
  selection_fg = '#c0caf5',
  selection_bg = '#33467C',
  
  scrollbar_thumb = '#292e42',
  
  split = '#565f89',
  
  ansi = {
    '#15161e',
    '#f7768e',
    '#9ece6a',
    '#e0af68',
    '#7aa2f7',
    '#bb9af7',
    '#7dcfff',
    '#a9b1d6',
  },
  
  brights = {
    '#414868',
    '#f7768e',
    '#9ece6a',
    '#e0af68',
    '#7aa2f7',
    '#bb9af7',
    '#7dcfff',
    '#c0caf5',
  },
  
  tab_bar = {
    background = '#1a1b26',
    active_tab = {
      bg_color = '#7aa2f7',
      fg_color = '#1a1b26',
      intensity = 'Bold',
    },
    inactive_tab = {
      bg_color = '#414868',
      fg_color = '#c0caf5',
    },
    inactive_tab_hover = {
      bg_color = '#565f89',
      fg_color = '#c0caf5',
    },
    new_tab = {
      bg_color = '#1a1b26',
      fg_color = '#c0caf5',
    },
    new_tab_hover = {
      bg_color = '#292e42',
      fg_color = '#c0caf5',
    },
  },
}

config.term = 'xterm-256color'

-- Key bindings
config.leader = { key = 'j', mods = 'CTRL', timeout_milliseconds = 8000 }

config.keys = {
  -- Tab control and navigation
  { key = 'c', mods = 'LEADER', action = act.SpawnTab 'CurrentPaneDomain' },
  { key = 'p', mods = 'LEADER', action = act.ActivateTabRelative(-1) },
  { key = 'n', mods = 'LEADER', action = act.ActivateTabRelative(1) },
  { key = 'Space', mods = 'LEADER|CTRL', action = act.ActivateLastTab },

  -- Pane control and navigation
  { key = 'h', mods = 'LEADER', action = act.ActivatePaneDirection 'Left' },
  { key = 'j', mods = 'LEADER', action = act.ActivatePaneDirection 'Down' },
  { key = 'k', mods = 'LEADER', action = act.ActivatePaneDirection 'Up' },
  { key = 'l', mods = 'LEADER', action = act.ActivatePaneDirection 'Right' },
  { key = 'z', mods = 'LEADER', action = act.TogglePaneZoomState },
  { key = '"', mods = 'LEADER|SHIFT',
    action = act.SplitVertical { domain = 'CurrentPaneDomain' },

  },
  {
    key = '%',
    mods = 'LEADER|SHIFT',
    action = act.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },

  -- tmux style command palette
  { key = ':', mods = 'LEADER|SHIFT', action = act.ActivateCommandPalette },

  -- Fullscreen toggle
  { key = 'Enter', mods = 'CMD', action = act.ToggleFullScreen },


  {
    key = ',',
    mods = 'LEADER',
    action = act.PromptInputLine {
      description = 'Tab name',
      action = wezterm.action_callback(function(window, pane, line)
        -- line will be `nil` if they hit escape without entering anything
        -- An empty string if they just hit enter
        -- Or the actual line of text they wrote
        if line then
          window:active_tab():set_title(line)
        end
      end),
    },
  },

  -- tmux style key bindings for search and copy
  {
    key = '[',
    mods = 'LEADER',
    action = act.Multiple {
      --act.SendKey { key = 's', mods = 'CTRL' },
      act.ActivateKeyTable {
        name = 'copy_mode',
        one_shot = false,
      },
    },
  },
}

config.key_tables = {
  copy_mode = {
    { key = 'k', action = act.ScrollByLine(-1) },
    { key = 'j', action = act.ScrollByLine(1) },
    { key = 's', mods = 'CTRL', action = act.CopyMode 'ClearPattern' },
    { key = 'u', mods = 'CTRL', action = act.ScrollByPage(-1) },
    { key = 'd', mods = 'CTRL', action = act.ScrollByPage(1) },
    { key = 'N', mods = 'SHIFT', action = act.CopyMode 'NextMatch' },
    { key = 'n', mods = 'NONE', action = act.CopyMode 'PriorMatch' },
    { key = 'DownArrow', mods = 'NONE', action = act.CopyMode 'NextMatch' },
    { key = 'UpArrow', mods = 'NONE', action = act.CopyMode 'PriorMatch' },
    { key = "/", mods = "NONE", action = act { Search = { CaseSensitiveString="" }}},
    { key = "?", mods = "SHIFT", action = { Search = { CaseSensitiveString = "" }}},
    { key = 'Escape',
      action = act.Multiple {
        act.CopyMode 'Close',
        'PopKeyTable',
        'ScrollToBottom',
        --act.SendKey { key = 'q', mods = 'CTRL' },
      },
    },
    { key = 'q',
      action = act.Multiple {
        act.CopyMode 'Close',
        'PopKeyTable',
        'ScrollToBottom',
        --act.SendKey { key = 'q', mods = 'CTRL' },
      },
    },
    { key = 'c',
      mods = 'CTRL',
      action = act.Multiple {
        act.CopyMode 'Close',
        'PopKeyTable',
        'ScrollToBottom',
        --act.SendKey { key = 'q', mods = 'CTRL' },
      },
    },
  },
  search_mode = {
    -- These are a hack as I don't know if there is a way to disable key
    -- bindings that are currently active (in the preceding copy mode)
    { key = 'k', mods = 'NONE', action = act.SendKey { key = 'k' }},
    { key = 'j', mods = 'NONE', action = act.SendKey { key = 'j' }},
    { key = 'n', mods = 'NONE', action = act.SendKey { key = 'n' }},
    { key = 'N', mods = 'SHIFT', action = act.SendKey { key = 'N', mods = 'SHIFT' }},
    { key = 'q', mods = 'NONE', action = act.SendKey { key = 'q' }},
    { key = '/', mods = 'NONE', action = act.SendKey { key = '/' }},
    { key = '?', mods = 'SHIFT', action = act.SendKey { key = '?', mods = 'SHIFT' }},
    { key = 'Enter', mods = 'NONE', action = 'ActivateCopyMode'},
    { key = 'Escape',
      action = act.Multiple {
        act.CopyMode 'Close',
        'PopKeyTable',
        'ScrollToBottom',
        --act.SendKey { key = 'q', mods = 'CTRL' },
      },
    },
  },
}

for i = 1, 9 do
  table.insert(config.keys, {
    key = tostring(i),
    mods = 'LEADER',
    action = act.ActivateTab(i - 1),
  })
end

-- Show which key table is active in the status area
wezterm.on('update-right-status', function(window, pane)
  local name = window:active_key_table()
  if name then
    name = 'TABLE: ' .. name
  end
  window:set_right_status(name or '')
end)

-- The filled in variant of the < symbol
local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_right_hard_divider

-- The filled in variant of the > symbol
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider

-- This function returns the suggested title for a tab.
-- It prefers the title that was set via `tab:set_title()`
-- or `wezterm cli set-tab-title`, but falls back to the
-- title of the active pane in that tab.
function tab_title(tab_info)
  local title = tab_info.tab_title
  -- if the tab title is explicitly set, take that
  if title and #title > 0 then
    return title
  end
  -- Otherwise, use the title from the active pane
  -- in that tab
  return tab_info.active_pane.title
end

-- Custom tab formatting with padding
wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
  local title = tab_title(tab)
  
  -- Add padding to the tab title
  local padded_title = '  ' .. title .. '  '
  
  return {
    { Text = padded_title },
  }
end)

return config
