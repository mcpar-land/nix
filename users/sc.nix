{
  config,
  pkgs,
  ...
}: {
  imports = [];

  home.username = "sc";
  home.homeDirectory = "/home/sc";

  # programs.discord = {
  #   enable = true;
  #   wrapDiscord = true;
  # };

  home.packages = with pkgs; [
    spotify
    chatterino2
    streamlink
    # (pkgs.discord.override {
    #   withOpenASAR = true;
    #   withVencord = true;
    # })
  ];

  home.file = {
    # automatically launch steam on login
    ".config/autostart/steam.desktop".source = ../configs/sc/autostart/steam.desktop;
  };
}
