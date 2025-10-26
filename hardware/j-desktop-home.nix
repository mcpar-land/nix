{pkgs, ...}: {
  wayland.windowManager.sway.config.output = {
    "HDMI-A-1" = {
      mode = "1920x1080@60Hz";
      position = "0,0";
    };
    "DP-2" = {
      mode = "1920x1080@60Hz";
      position = "1920,0";
    };
    "DP-3" = {
      mode = "1920x1080@60Hz";
      position = "3840,0";
    };
  };
}
