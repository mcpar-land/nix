{
  pkgs,
  theme,
  ...
}: {
  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;
    extraConfig = ''
      local wezterm = require 'wezterm'
      return {
        window_background_opacity = 0.75,
        hide_tab_bar_if_only_one_tab = true,
        use_fancy_tab_bar = false,
        colors = {
          foreground = '${theme.base8.hex}',
          background = '${theme.base0.hex}',
          ansi = {
            '${theme.base0.hex}',
            '${theme.red.hex}',
            '${theme.green.hex}',
            '${theme.yellow.hex}',
            '${theme.blue.hex}',
            '${theme.magenta.hex}',
            '${theme.cyan.hex}',
            '${theme.base7.hex}',
          },
          brights = {
            '${theme.base4.hex}',
            '${theme.light.red.hex}',
            '${theme.light.green.hex}',
            '${theme.light.yellow.hex}',
            '${theme.light.blue.hex}',
            '${theme.light.magenta.hex}',
            '${theme.light.cyan.hex}',
            '${theme.base8.hex}',
          },
        },
        window_padding = {
          left = '8px',
          right = '8px',
          top = '8px',
          bottom = '8px',
        },
        font_size = 11.0,
        cell_width = 0.8,
        font_rules = {
          {
            italic = false,
            intensity = 'Normal',
            font = wezterm.font {
              family = 'Iosevka Comfy Fixed',
              weight = 'Regular',
              italic = false,
            }
          },
          {
            italic = false,
            intensity = 'Bold',
            font = wezterm.font {
              family = 'Iosevka Comfy Fixed',
              weight = 'Bold',
              italic = false,
            }
          },
          {
            italic = true,
            intensity = 'Normal',
            font = wezterm.font {
              family = 'Iosevka Comfy Fixed',
              weight = 'Regular',
              italic = true,
            }
          },
          {
            italic = true,
            intensity = 'Bold',
            font = wezterm.font {
              family = 'Iosevka Comfy Fixed',
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
    '';
  };
}
