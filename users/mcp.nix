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
    ../apps/jiratui.nix
  ];

  home.username = "mcp";
  home.homeDirectory = "/home/mcp";
  # home.file."./.background-image".source = ../wallpapers/disco_church.png;
  home.packages = with pkgs; [
    # terminal apps
    sops
    awscli2
    aws-vault
    mysql80
    kubectl

    # gui apps
    slack
    zoom-us
    (pkgs.callPackage ../derivations/drsprinto.nix {})
  ];

  programs.k9s = {
    enable = true;
  };

  age.secrets.aws-config = {
    file = ../secrets/aws_config.age;
    path = ".aws/config";
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

  systemd.user.enable = true;

  systemd.user.services.sshfs-civera-ftp = import ../units/sshfs_systemd.nix {
    inherit pkgs;
    host = "civera-ftp";
    description = "Civera SFTP Server";
    dir = "/home/mcp/mnt/civera_ftp";
  };

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
