# Common configuration file shared between ALL users.
{
  lib,
  config,
  pkgs,
  self,
  ...
}: {
  environment.systemPackages = with pkgs; [
    vesktop
    ntfs3g
    udiskie
    xdotool
    xsel
    j-ctl
    via # for keyboard
    qmk
    pulseaudio # for pactl, does not actually run the server
  ];

  fonts.packages = with pkgs; [
    corefonts
    fira
    fira-code-nerdfont
    font-awesome
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];

  # programs.hyprland.enable = true;

  # steam has to be installed globally.
  programs.steam = {
    enable = true;
    # remotePlay.openFirewall = true;
    # dedicatedServer.openFirewall = true;
  };

  # because it needs to edit /etc/shells, we have to set default shell globally
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # install docker
  virtualisation.docker.enable = true;

  services.tailscale = {
    enable = true;
  };
  # systemd.services.tailscale-autoconnect = {
  #   wantedBy = ["default.target"];
  #   after = ["tailscaled.service"];
  #   wants = ["tailscaled.service"];
  #   serviceConfig = {
  #     User = "mcp";
  #   };
  # };

  services.gnome.gnome-keyring.enable = true;

  users.users.sc = {
    isNormalUser = true;
    description = "sc";
    extraGroups = ["networkmanager" "wheel" "docker" "video"];
    openssh.authorizedKeys.keyFiles = [
      ./configs/ssh/id_rsa.pub
    ];
  };
  users.users.mcp = {
    isNormalUser = true;
    description = "mcp";
    extraGroups = ["networkmanager" "wheel" "docker" "video"];
    openssh.authorizedKeys.keyFiles = [
      ./configs/ssh/id_rsa.pub
    ];
  };

  nix.settings.trusted-users = ["root" "mcp" "sc"];

  nixpkgs.config.allowUnfree = true;

  nix.optimise.automatic = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  services.logind = {
    extraConfig = "HandlePowerKey=suspend";
    lidSwitch = "suspend";
  };

  services.displayManager = {
    defaultSession = "none+i3";
    autoLogin.enable = false;
  };

  services.xserver = {
    enable = true;
    xkb.layout = "us";
    xkb.variant = "";
    windowManager.i3.enable = true;
    displayManager.lightdm = {
      enable = true;
      greeter.enable = true;
      background = "${./wallpapers/martinaise.png}";
    };
    xautolock = {
      enable = true;
      enableNotifier = true;
      locker = "${pkgs.xlockmore}/bin/xlock";
      notifier = ''${pkgs.libnotify}/bin/notify-send "Locking in 10 seconds"'';
      time = 120;
    };
  };

  systemd.services.lightLocker = {
    description = "Light Locker Daemon";
    partOf = ["graphical-session.target"];
    serviceConfig = {
      Type = "forking";
    };
  };

  services.openssh = {
    enable = true;
    ports = [5346];
    openFirewall = true;
    allowSFTP = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      AllowUsers = ["sc" "mcp"];
    };
  };

  hardware.keyboard.qmk.enable = true;

  services.udisks2.enable = true;
  services.udev = {
    packages = [pkgs.via];
    enable = true;
    extraRules = ''
      ACTION=="add", SUBSYSTEM=="usb", RUN+="${pkgs.alsa-utils}/bin/aplay ${./sounds/plug_in.wav}"
      ACTION=="remove", SUBSYSTEM=="usb", RUN+="${pkgs.alsa-utils}/bin/aplay ${./sounds/plug_out.wav}"
    '';
  };

  system.stateVersion = "23.11";
}
