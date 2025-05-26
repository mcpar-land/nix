{
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    mangohud
  ];
  home.file."./.config/MangoHud/MangoHud.conf".text = ''
    exec_name
    fps_limit=60
    fps_color_change
    fps_limit_method=early
    gamemode
    horizontal
    position=top-center
    throttling_status
    version
  '';
}
