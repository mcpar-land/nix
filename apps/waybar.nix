{pkgs, ...}: {
  programs.waybar.enable = true;
  programs.waybar.systemd.enable = true;
  programs.waybar.settings = {
    mainBar = {
      modules-left = [
        "sway/workspaces"
      ];
      modules-right = [
        "mpd"
        "pulseaudio"
        "network"
        "power-profiles-daemon"
        "cpu"
        "memory"
        "temperature"
        "backlight"
        "keyboard-state"
        "sway/language"
        "battery"
        "battery#bat2"
        "clock"
        "tray"
        "custom/power"
      ];
      keyboard-state = {
        numlock = true;
        capslock = true;
        scrollock = true;
      };
    };
  };
}
