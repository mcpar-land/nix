{
  config,
  lib,
  pkgs,
  theme,
  ...
}: {
  imports = [
    ./apps/alacritty.nix
    ./apps/helix.nix
    ./apps/i3.nix
    # ./apps/i3bars.nix
    ./apps/polybar.nix
    ./apps/rofi.nix
    ./apps/zellij.nix
    ./apps/zsh.nix
  ];

  home.packages = with pkgs; [
    # terminal apps
    nnn
    zip
    xz
    unzip
    ripgrep
    gh
    git
    lshw
    lazygit
    gnumake
    tree
    imagemagick
    pkg-config
    yt-dlp

    # languages
    rustup
    go
    nodejs_18
    bun
    nil # nix lsp?
    alejandra # nix formatter
    gcc
    gleam
    erlang
    rebar3

    # gui apps
    firefox
    google-chrome
    vscode
    alacritty
    libreoffice-qt
    hardinfo
    obsidian
    vlc
    pinta
    flameshot
    gnome.nautilus
    gnome.sushi
    dbeaver
    bruno

    # fonts
    fira
    fira-code-nerdfont
    font-awesome

    dconf
    feh
    (betterlockscreen.override {withDunst = false;})
  ];

  home.sessionPath = [
    "$HOME/.cargo/bin"
  ];

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };

  services.screen-locker = {
    enable = true;
    xautolock = {
      enable = true;
    };
    lockCmd = "betterlockscreen --lock";
  };

  home.pointerCursor = {
    # package = pkgs.bibata-cursors;
    # name = "Bibata_Ghost";
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
    gtk.enable = true;
    x11.enable = true;
    x11.defaultCursor = "left_ptr";
  };

  gtk = {
    enable = true;
    font = {
      name = "Fira Sans";
      size = 11;
    };
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome.gnome-themes-extra;
    };
    gtk3.extraConfig.Settings = ''
      gtk-application-prefer-dark-theme=1
    '';
    gtk4.extraConfig.Settings = ''
      gtk-application-prefer-dark-theme=1
    '';
    # iconTheme = {
    #   package = pkgs.papirus-icon-theme;
    #   name = "Papirus-Dark";
    # };
    # theme = {
    #   package = pkgs.catppuccin-gtk.override {
    #     accents = ["peach"];
    #     size = "standard";
    #     variant = "mocha";
    #   };
    #   name = "Catppuccin-Mocha-Standard-Peach-Dark";
    # };
  };

  dconf.enable = true;
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  systemd.user = {
    startServices = "sd-switch";
  };

  # enable network applet in tray
  systemd.user.services.nmapplet = {
    Unit.Description = "Custom service for enabling the network applet";
    Unit.After = ["graphical-session-i3.target"];
    Install.WantedBy = ["graphical-session-i3.target"];
    Service.ExecStart = "${pkgs.networkmanagerapplet}/bin/nm-applet";
  };
  # wallpaper
  systemd.user.services.wallpaper = {
    Unit.Description = "Just uses feh to display the wallpaper";
    Unit.After = ["graphical-session-i3.target"];
    Install.WantedBy = ["graphical-session-i3.target"];
    Service.ExecStart = "${pkgs.feh}/bin/feh --bg-scale ${./wallpapers/martinaise2.png}";
  };

  home.file = {
    # "./.background-image" = {
    #   source = ./wallpapers/martinaise2.png;
    # };
  };

  home.sessionVariables = {
    EDITOR = "hx";
    BROWSER = "google-chrome-stable";
    TERMINAL = "alacritty";
  };

  home.stateVersion = "23.11";
}
