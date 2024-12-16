{
  config,
  lib,
  pkgs,
  theme,
  agenix,
  ...
}: {
  imports = [
    ./apps/aerc.nix
    ./apps/alacritty.nix
    ./apps/btop.nix
    ./apps/dunst.nix
    ./apps/git.nix
    ./apps/helix.nix
    ./apps/i3.nix
    ./apps/nnn/nnn.nix
    ./apps/rofi.nix
    ./apps/zellij.nix
    ./apps/zsh.nix
    ./apps/firefox/firefox.nix
    ./apps/newsboat.nix
    ./apps/spotify.nix
    ./apps/vscode.nix
    ./apps/custom-cmds.nix
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
    libxml2
    inetutils # whois, telnet, etc etc
    remarshal # json2toml, yaml2cbor, cbr2json, toml2json, etc.
    file # detect file type (how was this not installed??)
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
    openscad-lsp

    # gui apps
    alacritty
    audacity
    dbeaver-bin
    diffuse
    element-desktop
    filezilla
    flameshot
    hardinfo
    heaptrack
    libreoffice-qt
    obsidian
    pavucontrol
    pinta
    qdirstat
    simplescreenrecorder
    xfce.thunar
    unstable.imhex
    ungoogled-chromium
    vlc
    signal-desktop
    bambu-studio
    openscad-unstable
    mitmproxy
    wireshark

    dconf

    # misc dependencies
    playwright-driver.browsers

    # my custom derivations
    (pkgs.callPackage ./derivations/zipinfo-csv.nix {})
    (pkgs.callPackage ./derivations/uuinfo.nix {})
  ];

  programs.gpg = {
    enable = true;
  };
  services.gpg-agent = {
    enable = true;
    enableZshIntegration = true;
    # used to use pinentry-rofi but this caused problems when
    # using over ssh
    pinentryPackage = pkgs.pinentry-tty;
    # extraConfig = ''
    #   pinentry-program ${pkgs.pinentry-tty}/bin/pinentry-tty
    # '';
  };

  home.sessionVariables.NNN_OPTS = "diUxeEaP";
  home.sessionVariables.NNN_TERMINAL = "alacritty";

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
      "x-scheme-handler/terminal" = "Alacritty.desktop";
      "inode/directory" = "pcmanfm.desktop";
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
      package = pkgs.gnome-themes-extra;
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

  age.secrets.ssh_config = {
    file = ./secrets/ssh_config.age;
    path = ".ssh/includes/ssh-config-agenix";
  };

  home.file = {
    "./.npmrc".text = ''
      prefix=~/.npm-packages
    '';
    "./.ssh/config".text = ''
      Include ${lib.removePrefix ".ssh/" config.age.secrets.ssh_config.path}
    '';
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
    LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib";
  };

  home.stateVersion = "23.11";
}
