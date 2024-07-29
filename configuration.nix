# Common configuration file shared between ALL users.
{
  lib,
  config,
  pkgs,
  self,
  ...
}: {
  environment.systemPackages = with pkgs; [
    (unstable.vesktop.override {
      withSystemVencord = false;
    })
    ntfs3g
    udiskie
    xdotool
    xsel
    j-ctl
    via # for keyboard
    qmk
    pulseaudio # for pactl, does not actually run the server
    helvum # for pipewire GUI
    qemu
  ];

  fonts.packages = with pkgs; [
    corefonts
    fira
    fira-code-nerdfont
    font-awesome
    iosevka-comfy.comfy-motion-fixed
    iosevka-comfy.comfy-fixed
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];

  age.secrets.test_secret.file = ./secrets/test_secret.age;
  age.identityPaths = [
    "/home/sc/.ssh/id_rsa"
    "/home/mcp/.ssh/id_rsa"
  ];

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

  # need to enable this to compile C i think
  programs.nix-ld.enable = true;

  # enable gvfs (gnome virtual file system) for connecting to stuff in nautilus
  services.gvfs.enable = true;

  # # automatically mount raspi data via sshfs
  # # https://nixos.org/manual/nixos/stable/#sec-sshfs-file-systems
  # fileSystems."/mnt/raspi" = {
  #   device = "nixos@10.0.0.146:/data/";
  #   fsType = "sshfs";
  #   options = [
  #     "allow_other"
  #     "_netdev"
  #     "x-systemd.automount"
  #     "reconnect"
  #     "ServerAliveInterval=15"
  #     # gotta make this manually ig
  #     "IdentityFile=/root/.ssh/id_rsa"
  #     "debug"
  #   ];
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
      locker = "${pkgs.writeShellScript "styled-locker" ''i3lock-styled''}";
      notifier = ''${pkgs.libnotify}/bin/notify-send "Locking in 10 seconds"'';
      time = 30;
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

  # https://github.com/NixOS/nixpkgs/issues/180175#issuecomment-1658731959
  systemd.services.NetworkManager-wait-online = {
    serviceConfig = {
      ExecStart = ["" "${pkgs.networkmanager}/bin/nm-online -q"];
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
