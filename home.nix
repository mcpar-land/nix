{
  config,
  lib,
  pkgs,
  theme,
  ...
}: {
  imports = [
    ./apps/aerc.nix
    # ./apps/alacritty.nix
    ./apps/btop.nix
    ./apps/dunst.nix
    ./apps/git.nix
    ./apps/helix.nix
    ./apps/i3.nix
    ./apps/mangohud.nix
    # ./apps/nnn/nnn.nix
    ./apps/yazi.nix
    ./apps/rofi.nix
    ./apps/zsh.nix
    ./apps/firefox/firefox.nix
    ./apps/newsboat.nix
    ./apps/shpool.nix
    ./apps/spotify.nix
    ./apps/taskwarrior3.nix
    ./apps/vscode.nix
    ./apps/wezterm.nix
    ./apps/custom-cmds.nix
    ./apps/rclone.nix
    ./apps/dl-music.nix
  ];

  home.packages = with pkgs; [
    # terminal apps
    wget
    zip
    p7zip
    xz
    unzip
    ripgrep # https://github.com/BurntSushi/ripgrep
    lshw
    gnumake
    tree
    imagemagick
    pkg-config
    unstable.yt-dlp # https://github.com/yt-dlp/yt-dlp
    visidata # https://www.visidata.org/man/
    youplot # https://github.com/red-data-tools/YouPlot
    jq # https://jqlang.github.io/jq/
    yq-go # https://mikefarah.gitbook.io/yq
    unstable.xan # https://github.com/medialab/xan/
    jless # https://jless.io/
    jd-diff-patch # https://github.com/josephburnett/jd
    glow # https://github.com/charmbracelet/glow
    hurl # https://hurl.dev/
    rnr # https://github.com/ismaelgv/rnr
    youplot # https://github.com/red-data-tools/YouPlot
    unstable.duckdb
    pandoc
    ffmpeg
    devenv
    lazydocker
    watchexec
    systemctl-tui
    xorg.xev
    sshfs
    neofetch
    nmap
    s3fs # mount s3 on filesystem with fuse
    xclip # clipboard
    agenix
    wavemon # wifi signal analysis tui
    cyme # usb listing https://github.com/tuna-f1sh/cyme
    spotify-player
    librespot
    libxml2
    inetutils # whois, telnet, etc etc
    remarshal # json2toml, yaml2cbor, cbr2json, toml2json, etc.
    file # detect file type (how was this not installed??)
    streamlink
    taskwarrior-tui
    cachix
    tio
    # https://www.nongnu.org/renameutils/
    renameutils
    # to connect to wifi, use nmtui
    xautolock
    # i maintain this!
    unstable.git-who
    dust
    ipinfo
    parallel

    # languages
    rustup
    go
    gopls # go language server
    nodejs_22
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
    lua-language-server

    # python and formatters for python
    # lmao
    python312Full
    ruff

    # gui apps
    audacity
    dbeaver-bin
    diffuse
    element-desktop
    filezilla
    flameshot
    hardinfo2
    libreoffice-qt
    obsidian
    pavucontrol
    pinta
    krita
    qimgv
    qdirstat
    qFlipper
    simplescreenrecorder
    supersonic
    xfce.thunar
    ungoogled-chromium
    vlc
    signal-desktop
    orca-slicer
    openscad-unstable
    mitmproxy
    wireshark
    eartag

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
  # test
  services.gpg-agent = {
    enable = true;
    enableZshIntegration = true;
    # used to use pinentry-rofi but this caused problems when
    # using over ssh
    extraConfig = ''
      pinentry-program ${pkgs.pinentry-tty}/bin/pinentry-tty
    '';
  };

  home.sessionVariables.NNN_OPTS = "diUxeEaP";
  home.sessionVariables.NNN_TERMINAL = "wezterm";

  home.sessionPath = [
    "$HOME/.cargo/bin"
    "$HOME/.npm-packages/bin"
  ];

  programs.bat = {
    enable = true;
  };
  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    git = true;
    icons = "auto";
  };

  programs.direnv = {
    enable = true;
    package = pkgs.unstable.direnv;
    enableZshIntegration = true;
  };

  xdg.mimeApps.enable = true;
  xdg.mimeApps.defaultApplications = {
    # firefox
    "application/pdf" = "firefox.desktop";
    "x-scheme-handler/http" = "firefox.desktop";
    "x-scheme-handler/https" = "firefox.desktop";
    "x-scheme-handler/unknown" = "firefox.desktop";
    "x-scheme-handler/chrome" = "firefox.desktop";
    "application/x-extension-htm" = "firefox.desktop";
    "application/x-extension-html" = "firefox.desktop";
    "application/x-extension-shtml" = "firefox.desktop";
    "application/xhtml+xml" = "firefox.desktop";
    "application/x-extension-xhtml" = "firefox.desktop";
    "application/x-extension-xht" = "firefox.desktop";
    "image/png" = "firefox.desktop";
    "image/jpeg" = "firefox.desktop";
    "image/tiff" = "firefox.desktop";
    "image/gif" = "firefox.desktop";
    # vlc
    "audio/mp3" = "vlc.desktop";
    "audio/mp4" = "vlc.desktop";
    "video/mp4" = "vlc.desktop";
    "video/webm" = "vlc.desktop";
    # wezterm
    "x-scheme-handler/terminal" = "wezterm.desktop";
    # thunar
    "inode/directory" = "thunar.desktop";
  };

  # disabled when upgraded to 25.05 because it's not
  # accepting correctly input password??
  # services.screen-locker = {
  #   enable = true;
  #   lockCmd = "i3lock-styled";
  #   inactiveInterval = 10;
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
    TERMINAL = "wezterm";
    GTK_THEME = "Adwaita-dark";
    NIX_THEME = theme.asJson;
    PLAYWRIGHT_BROWSERS_PATH = "${pkgs.playwright-driver.browsers}";
    PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";
    # https://discourse.nixos.org/t/my-nix-package-is-broken/58050/17
    # apparently you should not do this
    # LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib";
  };

  home.stateVersion = "23.11";
}
