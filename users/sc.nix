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
    godot_4
    gdtoolkit
    r2modman
    vcv-rack

    jre_headless # for minecraft
    prismlauncher

    (pkgs.callPackage ../derivations/path-of-building.nix {})
    (pkgs.callPackage ../derivations/awakened-poe-trade.nix {})
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
