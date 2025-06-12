{pkgs, ...}: {
  programs.waybar.enable = true;
  programs.waybar.systemd.enable = false;
  programs.waybar.settings = {};
}
