{pkgs, ...}: let
  startScript = pkgs.writeShellScript "start-gamemode" ''
    ${pkgs.libnotify}/bin/notify-send 'GameMode started'
    makoctl mode -s gamemode-shush
  '';
  endScript = pkgs.writeShellScript "end-gamemode" ''
    makoctl mode -s default
    ${pkgs.libnotify}/bin/notify-send 'GameMode ended'
  '';
in {
  environment.systemPackages = with pkgs; [
    mangohud
  ];
  programs.gamemode = {
    enable = true;
    enableRenice = true;
    settings = {
      custom = {
        start = "${startScript}";
        end = "${endScript}";
      };
      cpu = {
        park_cores = true;
        pin_cores = true;
      };
    };
  };
}
