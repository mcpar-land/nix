{pkgs, ...}: let
  startScript = pkgs.writeShellScript "start-gamemode" ''
    ${pkgs.libnotify}/bin/notify-send 'GameMode started'
    makoctl mode -a gamemode-shush
  '';
  endScript = pkgs.writeShellScript "end-gamemode" ''
    makoctl mode -r gamemode-shush
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
