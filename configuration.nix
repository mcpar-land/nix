# Common configuration file shared between ALL users.
{
  lib,
  config,
  pkgs,
  self,
  ...
}: {
  imports = [
    ./apps/gamemode.nix
    ./apps/greetd.nix
  ];

  environment.systemPackages = with pkgs; [
    (vesktop.override {
      withSystemVencord = false;
    })
    ntfs3g
    udiskie
    j-ctl
    via # for keyboard
    qmk
    pulseaudio # for pactl, does not actually run the server
    helvum # for pipewire GUI
    qemu
    # for iphone
    libimobiledevice
    ifuse
    # antivirus
    clamav
    # network manager
    networkmanagerapplet
  ];

  fonts.packages = with pkgs; [
    corefonts
    fira
    nerd-fonts.fira-code
    font-awesome
    (iosevka.override {
      # https://typeof.net/Iosevka/customizer
      privateBuildPlan = {
        family = "Iosevka Custom";
        spacing = "term";
        serifs = "sans";
        noCvSs = true;
        exportGlyphNames = false;
        weights.Regular = {
          shape = 400;
          menu = 400;
          css = 400;
        };
        weights.Bold = {
          shape = 700;
          menu = 700;
          css = 700;
        };
        widths.Normal = {
          shape = 500;
          menu = 5;
          css = "normal";
        };
        slopes.Upright = {
          angle = 0;
          shape = "upright";
          menu = "upright";
          css = "normal";
        };
        slopes.Italic = {
          angle = 9.4;
          shape = "italic";
          menu = "italic";
          css = "italic";
        };
      };
      set = "Custom";
    })
  ];
  console = {
    earlySetup = true;
    font = "${pkgs.terminus_font}/share/consolefonts/ter-u14n.psf.gz";
    packages = with pkgs; [terminus_font];
    keyMap = "us";
  };

  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    auto-optimise-store = true;
    substituters = [
      "https://cache.nixos.org"
      # for fetching helix builds from cachix
      "https://helix.cachix.org"
    ];
    trusted-public-keys = [
      "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
    ];
  };
  nix.extraOptions = ''
    # so we can still build without a connection to jamrock
    fallback = true
  '';

  age.secrets.test_secret.file = ./secrets/test_secret.age;
  age.identityPaths = [
    "/home/sc/.ssh/id_rsa"
    "/home/mcp/.ssh/id_rsa"
  ];

  # for sway
  security.polkit.enable = true;

  # for iphone
  services.usbmuxd.enable = true;

  # steam has to be installed globally.
  programs.steam = {
    enable = true;
    # remotePlay.openFirewall = true;
    # dedicatedServer.openFirewall = true;
  };

  # so does wireshark
  programs.wireshark.enable = true;

  # and hamachi
  services.logmein-hamachi.enable = true;

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
  security.pam.services.lightdm.enableGnomeKeyring = true;

  # https://wiki.nixos.org/wiki/Serial_Console#Unprivileged_access_to_serial_device
  # the default group for serial devices is "dialout"

  users.users.sc = {
    isNormalUser = true;
    description = "sc";
    extraGroups = ["networkmanager" "wheel" "docker" "video" "wireshark" "dialout" "gamemode" "input"];
    openssh.authorizedKeys.keyFiles = [
      ./configs/ssh/id_rsa.pub
    ];
  };
  users.users.mcp = {
    isNormalUser = true;
    description = "mcp";
    extraGroups = ["networkmanager" "wheel" "docker" "video" "wireshark" "dialout" "gamemode" "input"];
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

  # this appears to intermittently work?
  # it works for opening files from firefox,
  # but opening files from pcman still does not work
  xdg.terminal-exec = {
    enable = true;
    settings = {
      GNOME = ["WezTerm.desktop" "wezterm.desktop"];
      default = ["WezTerm.desktop" "wezterm.desktop"];
    };
  };
  environment.variables.XDG_TERMINAL = "wezterm";

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
}
