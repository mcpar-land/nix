{
  config,
  pkgs,
  ...
}: {
  imports = [];

  home.username = "sc";
  home.homeDirectory = "/home/sc";

  home.packages = with pkgs; [
    spotify
    chatterino2
    streamlink
    path-of-building
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

  programs.firefox.profiles."sc" = {
    name = "SC";
    id = 0;
    isDefault = true;
  };

  programs.firefox.profiles."m" = {
    name = "M";
    id = 1;
  };
}
