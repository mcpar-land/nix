{
  pkgs,
  lib,
  ...
}: let
  mod = "Mod4";
  launchProfile = pkgs.writeShellScript "rofi-chrome" ''
    set -e
    SELECTED_PROFILE=$(j-ctl chrome list-profiles | rofi -dmenu -auto-select -p 'chrome')
    PROFILE_DIRECTORY=$(j-ctl chrome get-profile "$SELECTED_PROFILE")

    google-chrome-stable --profile-directory="$PROFILE_DIRECTORY"
  '';
in {
  home.packages = with pkgs; [
    google-chrome
  ];

  xsession.windowManager.i3.config.keybindings = lib.mkOptionDefault {
    "${mod}+b" = "exec --no-startup-id ${launchProfile}";
  };
}
