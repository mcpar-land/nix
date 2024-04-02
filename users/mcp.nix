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
    aws-vault
    mysql80

    # gui apps
    slack
    zoom-us
  ];

  home.sessionVariables = {
    # https://github.com/99designs/aws-vault/blob/master/USAGE.md#environment-variables
    AWS_SESSION_TOKEN_TTL = "12h";
  };
}
