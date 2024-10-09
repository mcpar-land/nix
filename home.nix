{
  config,
  lib,
  pkgs,
  theme,
  agenix,
  ...
}: {
  imports = [
    ./apps/alacritty.nix
    ./apps/btop.nix
    ./apps/dunst.nix
    ./apps/git.nix
    ./apps/helix.nix
    ./apps/i3.nix
    ./apps/rofi.nix
    ./apps/zellij.nix
    ./apps/zsh.nix
    ./apps/firefox/firefox.nix
    ./apps/newsboat.nix
    ./apps/spotify.nix
    ./apps/vscode.nix
  ];

  home.packages = with pkgs; [
    # terminal apps
    wget
    zip
    xz
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
    yq-go # https://mikefarah.gitbook.io/yq
    xsv # https://github.com/BurntSushi/xsv
    jless # https://jless.io/
    jd-diff-patch # https://github.com/josephburnett/jd
    glow # https://github.com/charmbracelet/glow
    hurl # https://hurl.dev/
    rnr # https://github.com/ismaelgv/rnr
    youplot # https://github.com/red-data-tools/YouPlot
    unstable.duckdb
    pandoc
    ffmpeg
    unstable.devenv
    lazydocker
    watchexec
    systemctl-tui
    xorg.xev
    sshfs
    neofetch
    nmap
    s3fs # mount s3 on filesystem with fuse
    xclip # clipboard
    agenix.packages.x86_64-linux.default
    wavemon # wifi signal analysis tui
    cyme # usb listing https://github.com/tuna-f1sh/cyme
    spotify-player
    librespot
    # to connect to wifi, use nmtui

    # languages
    rustup
    go
    gopls # go language server
    nodejs_18
    vscode-langservers-extracted
    bun
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
    unstable.superhtml

    # gui apps
    alacritty
    audacity
    dbeaver-bin
    diffuse
    filezilla
    flameshot
    gnome.nautilus
    gnome.sushi
    gnome.gnome-font-viewer
    hardinfo
    heaptrack
    libreoffice-qt
    obsidian
    pavucontrol
    pinta
    qdirstat
    simplescreenrecorder
    unstable.imhex
    ungoogled-chromium
    vlc

    dconf

    # misc dependencies
    playwright-driver.browsers
  ];

  programs.gpg = {
    enable = true;
  };
  services.gpg-agent = {
    enable = true;
    enableZshIntegration = true;
    extraConfig = ''
      pinentry-program ${pkgs.pinentry-rofi}/bin/pinentry-rofi
    '';
  };

  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      opener.jless_opener = [
        {
          run = "jless $0";
          block = true;
        }
      ];
      open = {
        prepend_rules = [
          {
            name = "*.json";
            use = "jless_opener";
          }
        ];
      };
    };
  };

  home.sessionPath = [
    "$HOME/.cargo/bin"
    "$HOME/.npm-packages/bin"
  ];

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };

  xdg.mimeApps.enable = true;
  xdg.mimeApps.defaultApplications = let
    defaultApplications = {
      "x-scheme-handler/terminal" = "alacritty.desktop";
      "inode/directory" = "nautilus.desktop";
    };
    browser = "firefox.desktop";
    openInBrowser = [
      "application/pdf"
      "x-scheme-handler/http"
      "x-scheme-handler/https"
      "x-scheme-handler/unknown"
      "x-scheme-handler/chrome"
      "application/x-extension-htm"
      "application/x-extension-html"
      "application/x-extension-shtml"
      "application/xhtml+xml"
      "application/x-extension-xhtml"
      "application/x-extension-xht"
      "image/png"
      "image/jpeg"
      "image/tiff"
      "image/gif"
    ];
  in
    defaultApplications
    // (builtins.listToAttrs (map (k: {
        name = k;
        value = browser;
      })
      openInBrowser));

  # xdg.desktopEntries = {
  #   logout = {
  #     name = "Logout";
  #     genericName = "Log Out";
  #     exec = "loginctl terminate-session \"\"";
  #   };
  #   lock = {
  #     name = "Lock";
  #     genericName = "Lock";
  #     exec = "i3lock-styled";
  #   };
  # };

  # services.screen-locker = {
  #   enable = true;
  #   xautolock = {
  #     enable = true;
  #   };
  #   lockCmd = "light-locker-command -l";
  # };

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

  services.udiskie = {
    enable = true;
    tray = "never";
  };

  home.file = {
    "./.npmrc".text = ''
      prefix=~/.npm-packages
    '';
    "./.ssh/config".source = ./configs/ssh/config;
  };

  home.sessionVariables = {
    EDITOR = "hx";
    VISUAL = "hx";
    BROWSER = "firefox";
    DELTA_PAGER = "less --mouse";
    TERMINAL = "alacritty";
    GTK_THEME = "Adwaita-dark";
    NIX_THEME = theme.asJson;
    PLAYWRIGHT_BROWSERS_PATH = "${pkgs.playwright-driver.browsers}";
    PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";
  };

  home.stateVersion = "23.11";
}
