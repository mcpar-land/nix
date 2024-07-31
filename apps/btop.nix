{
  config,
  lib,
  pkgs,
  theme,
  ...
}: {
  programs.btop = {
    enable = true;
    # for some reason i had this as using unstable btop. Don't remember why?
    # package = pkgs.unstable.btop;
    settings = {
      color_theme = "TTY";
      theme_background = false;
      proc_tree = false;
      vim_keys = true;
      temp_scale = "fahrenheit";
    };
  };
}
