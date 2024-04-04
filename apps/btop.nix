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
      color_theme = "monokai";
      proc_tree = true;
    };
  };
}
