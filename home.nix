{
  config,
  lib,
  pkgs,
  theme,
  ...
}: {
  imports = [
    ./apps/alacritty.nix
    ./apps/btop.nix
    ./apps/dunst.nix
    ./apps/git.nix
    ./apps/helix.nix
    ./apps/i3.nix
    ./apps/polybar.nix
    ./apps/rofi.nix
    ./apps/zellij.nix
    ./apps/zsh.nix
  ];

  home.packages = with pkgs; [
    # terminal apps
    zip
    # response to the xz 5.6.1 backdoor, im using xz stable instead
    stable.xz
    unzip
    ripgrep # https://github.com/BurntSushi/ripgrep
    lshw
    gnumake
    tree
    imagemagick
    pkg-config
    yt-dlp # https://github.com/yt-dlp/yt-dlp
    visidata # https://www.visidata.org/man/
    youplot # https://github.com/red-data-tools/YouPlot
    jq # https://jqlang.github.io/jq/
    xsv # https://github.com/BurntSushi/xsv
    jless # https://jless.io/
    duckdb
    pandoc
    ffmpeg

    # languages
    # rustup
    go
    gopls # go language server
    nodejs_18
    bun
    vscode-langservers-extracted
    nil # nix lsp?
    alejandra # nix formatter
    gcc
    gleam
    erlang
    rebar3
    marksman # markdown lsp
    stack # haskell package manager
    haskell-language-server
    ormolu # haskell formatter

    # gui apps
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
    pavucontrol
    qdirstat

    # fonts
    fira
    fira-code-nerdfont
    font-awesome

    dconf
    feh
    (betterlockscreen.override {withDunst = false;})
  ];

  programs.firefox = {
    enable = true;
  };

  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
  };

  home.sessionPath = [
    "$HOME/.cargo/bin"
    "$HOME/.npm-packages/bin"
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
  # automatically mount disks
  systemd.user.services.udiskie = {
    Unit.Description = "Udiskie uses udisks2 to automount inserted media";
    Install.WantedBy = ["multi-user.target"];
    Serivce.Type = "simple";
    Service.ExecStart = "${pkgs.udiskie}/bin/udiskie";
  };

  home.file = {
    "./.background-image" = {
      source = ./wallpapers/martinaise2.png;
    };
    "./.npmrc".text = ''
      prefix=~/.npm-packages
    '';
  };

  home.sessionVariables = {
    EDITOR = "hx";
    VISUAL = "hx";
    BROWSER = "google-chrome-stable";
    TERMINAL = "alacritty";
  };

  home.stateVersion = "23.11";
}
