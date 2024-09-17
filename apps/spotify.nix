{
  lib,
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    spotify
    spotify-player
  ];

  programs.zsh.shellAliases = {
    # spotify = "spotify_player";
    spoofy = "spotify_player";
  };
}
