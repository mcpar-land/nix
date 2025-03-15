{
  pkgs,
  theme,
  lib,
  ...
}: let
  configFile = builtins.readFile ./wezterm/config.lua;
in {
  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;
    extraConfig = ''
      THEME = ${theme.asLua}

      ${configFile}
    '';
  };
}
