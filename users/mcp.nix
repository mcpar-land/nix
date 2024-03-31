{
  config,
  pkgs,
  ...
}: {
  # imports = [
  #   ../home.nix
  # ];

  home.username = "mcp";
  home.homeDirectory = "/home/mcp";
  home.packages = with pkgs; [
    # terminal apps
    sops
    awscli
    mysql80

    # gui apps
    slack
    zoom-us
  ];
}
