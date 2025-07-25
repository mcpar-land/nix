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
  imports = [
    ../apps/syncthing.nix
    ../apps/vintagestory.nix
    ../apps/joystickwake.nix
  ];

  home.username = "sc";
  home.homeDirectory = "/home/sc";
  home.file."./.background-image".source = ../wallpapers/martinaise.png;

  home.packages = with pkgs; [
    spotify
    chatterino2
    godot_4
    gdtoolkit_4
    r2modman
    rpcs3

    jre_headless # for minecraft
    prismlauncher

    (pkgs.callPackage ../derivations/path-of-building.nix {})
    (pkgs.callPackage ../derivations/awakened-poe-trade.nix {})
    (pkgs.callPackage ../derivations/inky.nix {})
  ];

  xdg.desktopEntries = {
    pathofbuilding = {
      name = "Path of Building";
      genericName = "Build Planner";
      exec = "pobfrontend";
      terminal = false;
      categories = ["Game" "Utility"];
    };
    awakened-poe-trade = {
      name = "Awakened PoE Trade";
      genericName = "Trading Utility";
      exec = "awakened-poe-trade";
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
