{
  pkgs,
  theme,
  lib,
  ...
}: {
  systemd.user.services.polybar.Install.WantedBy = lib.mkForce ["graphical-session-i3.target"];
  systemd.user.services.polybar.Unit.After = lib.mkForce ["graphical-session-i3.target"];
  # systemd.user.services.polybar.Service.Type = lib.mkForce "simple";
  services.polybar.enable = true;
  services.polybar.package = pkgs.polybarFull;
  services.polybar.config = {
    "bar/base" = {
      width = "100%";
      height = "3%";
      radius = 0;
      background = theme.base0.hex;
      font-0 = "Fira Sans:size=11;2";
      modules-center = "date";
      modules-left = "i3";
    };

    "bar/primary" = {
      "inherit" = "bar/base";
      monitor = "";
      modules-right = "battery tray";
    };

    "bar/secondary1" = {
      "inherit" = "bar/base";
      monitor = "DisplayPort-2";
    };

    "bar/secondary2" = {
      "inherit" = "bar/base";
      monitor = "HDMI-A-0";
    };

    "module/date" = {
      type = "internal/date";
      internal = 5;
      date = "%a %b %d";
      time = "%I:%M %p";
      label = "%time%  %date%";
    };

    "module/battery" = {
      type = "internal/battery";
      battery = "BAT0";
      adapter = "AC";
      low-at = 20;
      full-at = 99;
    };

    "module/tray" = {
      type = "internal/tray";
      tray-spacing = 4;
    };

    "module/i3" = let
      padding = 2;
    in {
      type = "internal/i3";

      pin-workspaces = true;
      enable-scroll = false;

      label-focused-padding = padding;
      label-unfocused-padding = padding;
      label-visible-padding = padding;
      label-urgent-padding = padding;

      label-focused-background = theme.blue.hex;
      label-focused-foreground = theme.base0.hex;

      label-focused = "%name%";
      label-unfocused = "%name%";
      label-visible = "%name%";
      label-urgent = "%name%";
    };
  };
  # for m in $(polybar --list-monitors | grep -v "primary" | cut -d":" -f1); do
  #   MONITOR=$m polybar --reload secondary &
  # done
  # polybar --reload primary &
  services.polybar.script = toString (pkgs.writeShellScript "launch_polybar.sh" ''
    polybar primary &
    polybar secondary1 &
    polybar secondary2 &
  '');
}
