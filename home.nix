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
    ./apps/i3bars.nix
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
    gnome.nautilus
    gnome.sushi

    # fonts
    fira
    fira-code-nerdfont

    font-awesome
    dconf
    feh
  ];

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
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };
    theme = {
      package = pkgs.catppuccin-gtk.override {
        accents = ["peach"];
        size = "standard";
        variant = "mocha";
      };
      name = "Catppuccin-Mocha-Standard-Peach-Dark";
    };
  };

  dconf.enable = true;
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
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
