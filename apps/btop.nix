{
  config,
  lib,
  pkgs,
  theme,
  ...
}: {
  programs.btop = {
    enable = true;
    settings = {
      color_theme = "TTY";
      theme_background = false;
      proc_tree = false;
      vim_keys = true;
      temp_scale = "fahrenheit";
    };
  };
}
