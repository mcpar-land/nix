{
  pkgs,
  lib,
  ...
}: let
  mod = "Mod4";
  launchProfile = pkgs.writeShellScript "rofi-firefox" ''
    set -e
    SELECTED_PROFILE=$(j-ctl firefox list-profiles | rofi -i -auto-select -dmenu -p 'firefox')

    firefox -P $SELECTED_PROFILE &
  '';
in {
  programs.firefox = {
    enable = true;
  };
  xsession.windowManager.i3.config.keybindings = lib.mkOptionDefault {
    "${mod}+b" = "exec --no-startup-id ${launchProfile}";
  };
}
