{pkgs, ...}: {
  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;
    extraConfig = ''
      local wezterm = require 'wezterm'
      return {
        color_scheme = "Mikado (terminal.sexy)",
        window_background_opacity = 0.75,
        hide_tab_bar_if_only_one_tab = true,
        use_fancy_tab_bar = false,
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
            action = wezterm.action.ActivatePaneDirection 'Prev',
          },
          {
            key = 'l',
            mods = 'ALT',
            action = wezterm.action.ActivatePaneDirection 'Next',
          },
          {
            key = '[',
            mods = 'ALT',
            action = wezterm.action.ActivateTabRelative(-1),
          },
          {
            key = ']',
            mods = 'ALT',
            action = wezterm.action.ActivateTabRelative(1),
          },

          {
            key = 'h',
            mods = 'ALT|SHIFT',
            action = wezterm.action.RotatePanes 'CounterClockwise',
          },
          {
            key = 'l',
            mods = 'ALT|SHIFT',
            action = wezterm.action.RotatePanes 'Clockwise',
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
