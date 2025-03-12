{pkgs, ...}: {
  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;
    extraConfig = ''
      local wezterm = require 'wezterm'
      return {
        color_scheme = "Mikado (terminal.sexy)",
        hide_tab_bar_if_only_one_tab = true,
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
        }
      }
    '';
  };
}
