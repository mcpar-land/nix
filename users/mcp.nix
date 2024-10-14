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
  home.file."./.background-image".source = ../wallpapers/disco_church.png;
  home.packages = with pkgs; [
    # terminal apps
    sops
    awscli2
    aws-vault
    mysql80
    kubectl
    # https://github.com/ankitpokhrel/jira-cli
    jira-cli-go

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

  systemd.user.enable = true;

  # Is there some reason why this deviates from the wiki suggested way to mount with sshfs?
  # Maybe it's because it's for a specific user?
  systemd.user.services.mount-civera-ftp = {
    Unit = {
      Description = "Civera SFTP Server";
    };
    Install = {
      WantedBy = ["default.target"];
    };
    Service = {
      ExecStart = "${pkgs.sshfs}/bin/sshfs civera-ftp: /home/mcp/mnt/civera_ftp -f -v -o auto_unmount";
      Restart = "always";
      ExecStop = "${pkgs.fuse}/bin/fusermount -uz /home/mcp/mnt/civera_ftp";
    };
  };

  programs.firefox.profiles."mcp" = firefoxProfile {
    name = "McP";
    id = 0;
    isDefault = true;
  };

  programs.zsh.initExtra = ''
    export JIRA_API_TOKEN=$(cat ~/.jira-api-token)
  '';

  home.sessionVariables = {
    # https://github.com/99designs/aws-vault/blob/master/USAGE.md#environment-variables
    AWS_SESSION_TOKEN_TTL = "12h";
  };
}
