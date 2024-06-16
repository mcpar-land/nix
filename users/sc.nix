{
  config,
  pkgs,
  lib,
  ...
}: let
  firefoxProfile = import ../apps/firefox/profile.nix {
    inherit pkgs;
    inherit lib;
  };
in {
  imports = [];

  home.username = "sc";
  home.homeDirectory = "/home/sc";

  home.packages = with pkgs; [
    spotify
    chatterino2
    streamlink
    path-of-building
    godot_4
    gdtoolkit
    minecraft
  ];

  xdg.desktopEntries = {
    pathofbuilding = {
      name = "Path of Building";
      genericName = "Build Planner";
      exec = "pobfrontend";
      terminal = false;
      categories = ["Game" "Utility"];
    };
  };

  programs.firefox.profiles."sc" = firefoxProfile {
    name = "J";
    id = 0;
    isDefault = true;
  };

  programs.firefox.profiles."mcp" = firefoxProfile {
    name = "McP";
    id = 1;
  };

  programs.firefox.profiles."ct" = firefoxProfile {
    name = "CT";
    id = 2;
  };
}
