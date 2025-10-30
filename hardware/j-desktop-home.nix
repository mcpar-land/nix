{
  pkgs,
  name,
  user-wallpapers,
  ...
}: let
  bg = "${user-wallpapers.${name}} stretch";
in {
  wayland.windowManager.sway.config.output = {
    "HDMI-A-1" = {
      inherit bg;
      mode = "1920x1080@60Hz";
      position = "0,0";
    };
    "DP-2" = {
      inherit bg;
      mode = "1920x1080@60Hz";
      position = "1920,0";
    };
    "DP-3" = {
      inherit bg;
      mode = "1920x1080@60Hz";
      position = "3840,0";
    };
  };
}
