local wezterm = require 'wezterm'

local theme = THEME

TAB_BAR_BG = theme.base2
TAB_BG_INACTIVE = theme.base0
TAB_FG_INACTIVE = theme.base8
TAB_BG_ACTIVE   = theme.green
TAB_FG_ACTIVE   = theme.base0
RIGHT_ARROW     = wezterm.nerdfonts.pl_left_hard_divider
FONT = "GohuFont uni14 Nerd Font"

wezterm.on('format-tab-title', function(tab, tabs, _, _, hover, max_width)
  local title = tab.tab_title
  if title and #title > 0 then
    title = title
  else
    title = tab.active_pane.title
  end

  -- tab indexes start at 0
  local is_last = tab.tab_index == #tabs - 1

  local next_is_active = false
  if not is_last and tabs[tab.tab_index + 2].is_active then
    next_is_active = true
  end

  local bg = TAB_BG_INACTIVE
  local fg = TAB_FG_INACTIVE
  if tab.is_active then
    bg = TAB_BG_ACTIVE
    fg = TAB_FG_ACTIVE
  end
  local arrow_bg = TAB_BG_INACTIVE
  local arrow_fg = bg
  if next_is_active then
    arrow_bg = TAB_BG_ACTIVE
  end
  if is_last then
    arrow_bg = TAB_BAR_BG
  end

  return {
    { Background = { Color = bg } },
    { Foreground = { Color = fg } },
    { Text = ' ' .. tab.tab_index .. ': ' .. title .. ' ' },
    { Background = { Color = arrow_bg } },
    { Foreground = { Color = arrow_fg } },
    { Text = RIGHT_ARROW }
  }
end)

return {
  window_background_opacity = 0.95,
  hide_tab_bar_if_only_one_tab = true,
  use_fancy_tab_bar = false,
  tab_max_width = 48,
  show_new_tab_button_in_tab_bar = false,
  window_frame = {
    font = wezterm.font { family = FONT },
  },
  window_close_confirmation = 'NeverPrompt',
  window_background_gradient = {
    orientation = 'Vertical',
    colors = {
      theme.base3,
      theme.base0,
    },
  },
  colors = {
    foreground = theme.base8,
    background = theme.base0,
    cursor_bg = theme.green,
    cursor_fg = theme.base0,
    cursor_border = theme.green,
    selection_fg = theme.base0,
    selection_bg = theme.magenta,
    tab_bar = {
      background = theme.base2,
    },
    ansi = {
      theme.base0,
      theme.red,
      theme.green,
      theme.yellow,
      theme.blue,
      theme.magenta,
      theme.cyan,
      theme.base7,
    },
    brights = {
      theme.base5,
      theme.light.red,
      theme.light.green,
      theme.light.yellow,
      theme.light.blue,
      theme.light.magenta,
      theme.light.cyan,
      theme.base8,
    },
  },
  window_padding = {
    left = '8px',
    right = '8px',
    top = '8px',
    bottom = '8px',
  },
  font_size = 10.206,
  cell_width = 1.0,
  font_rules = {
    {
      italic = false,
      intensity = 'Normal',
      font = wezterm.font {
        family = FONT,
        weight = 'Regular',
        italic = false,
      }
    },
    {
      italic = false,
      intensity = 'Bold',
      font = wezterm.font {
        family = FONT,
        weight = 'Bold',
        italic = false,
      }
    },
    {
      italic = true,
      intensity = 'Normal',
      font = wezterm.font {
        family = FONT,
        weight = 'Regular',
        italic = true,
      }
    },
    {
      italic = true,
      intensity = 'Bold',
      font = wezterm.font {
        family = FONT,
        weight = 'Regular',
        italic = true,
      }
    },
  },
  leader = {
    key = 'Space',
    mods = 'ALT',
    timeout_milliseconds = 1000,
  },
  keys = {
    {
      key = 'n',
      mods = 'ALT',
      action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' }
    },
    {
      key = 'n',
      mods = 'ALT|SHIFT',
      action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' }
    },
    {
      key = 'h',
      mods = 'ALT',
      action = wezterm.action.ActivateTabRelative(-1),
    },
    {
      key = 'j',
      mods = 'ALT',
      action = wezterm.action.ActivatePaneDirection 'Next',
    },
    {
      key = 'k',
      mods = 'ALT',
      action = wezterm.action.ActivatePaneDirection 'Prev',
    },
    {
      key = 'l',
      mods = 'ALT',
      action = wezterm.action.ActivateTabRelative(1),
    },
    {
      key = 'p',
      mods = 'ALT',
      action = wezterm.action.PaneSelect,
    },

    {
      key = 'h',
      mods = 'ALT|SHIFT',
      action = wezterm.action.MoveTabRelative(-1),
    },
    {
      key = 'j',
      mods = 'ALT|SHIFT',
      action = wezterm.action.RotatePanes 'Clockwise',
    },
    {
      key = 'k',
      mods = 'ALT|SHIFT',
      action = wezterm.action.RotatePanes 'CounterClockwise',
    },
    {
      key = 'l',
      mods = 'ALT|SHIFT',
      action = wezterm.action.MoveTabRelative(1),
    },
    {
      key = 'p',
      mods = 'ALT|SHIFT',
      action = wezterm.action.PaneSelect { mode = 'SwapWithActive' },
    },

    {
      key = 'p',
      mods = 'CTRL|SHIFT',
      action = wezterm.action.ActivateCommandPalette,
    },
  }
}
