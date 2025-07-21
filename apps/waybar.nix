{pkgs, ...}: {
  programs.waybar.enable = true;
  programs.waybar.systemd.enable = true;
  programs.waybar.settings = {
    mainBar = {
      modules-left = [
        "keyboard-state"
      ];
      modules-right = [
        "mpd"
        "idle_inhibitor"
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
