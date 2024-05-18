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
  home.username = "mcp";
  home.homeDirectory = "/home/mcp";
  home.packages = with pkgs; [
    # terminal apps
    sops
    awscli
    aws-vault
    mysql80
    kubectl

    # gui apps
    slack
    zoom-us
  ];

  programs.k9s = {
    enable = true;
  };

  # systemd.user.services.tailscale-autoconnect = {
  #   Unit.Description = "Automatically connect to tailscale";
  #   Install.WantedBy = ["default.target"];
  #   Unit.PartOf = ["default.target"];
  #   Service.ExecStart = "${pkgs.tailscale}/bin/tailscale up --accept-dns=true --accept-routes=true";
  #   Service.RemainAfterExit = true;
  #   Service.ExecStop = "${pkgs.tailscale}/bin/tailscale down";
  #   Service.Type = "oneshot";
  # };

  programs.firefox.profiles."mcp" = firefoxProfile {
    name = "McP";
    id = 0;
    isDefault = true;
  };

  home.sessionVariables = {
    # https://github.com/99designs/aws-vault/blob/master/USAGE.md#environment-variables
    AWS_SESSION_TOKEN_TTL = "12h";
  };
}
