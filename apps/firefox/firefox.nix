{
  pkgs,
  lib,
  ...
}: let
  launchProfile = pkgs.writeShellScriptBin "rofi-firefox" ''
    set -e
    SELECTED_PROFILE=$(j-ctl firefox list-profiles | rofi -i -auto-select -dmenu -p 'firefox')

    firefox -P $SELECTED_PROFILE &
  '';
in {
  home.packages = [
    launchProfile
  ];
  programs.firefox = {
    enable = true;
  };
}
