{pkgs, ...}: {
  programs.wezterm = {
    package = pkgs.wezterm;
    enable = true;
    enableZshIntegration = true;
    extraConfig = ''
      local wezterm = require 'wezterm'

      local config = wezterm.config_builder()

      config.color_scheme = 'AdventureTime'

      config.font = wezterm.font {
        family = 'Iosevka Custom'
      }
      config.font_size = 11

      config.use_fancy_tab_bar = false

      config.window_background_opacity = 0.75

      config.window_padding = {
        left = '1cell',
        right = '1cell',
        top = '0cell',
        bottom = '0cell'
      }

      return config
    '';
  };
}
