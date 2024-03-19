# Common configuration file shared between ALL users.
{
  config,
  pkgs,
  self,
  ...
}: {
  environment.systemPackages = with pkgs; [
    vesktop
    ntfs3g
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

  users.users.sc = {
    isNormalUser = true;
    description = "sc";
    extraGroups = ["networkmanager" "wheel" "docker"];
  };
  users.users.mcp = {
    isNormalUser = true;
    description = "mcp";
    extraGroups = ["networkmanager" "wheel" "docker"];
  };

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

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
    # desktopManager.xfce.enable = true;
    windowManager.i3.enable = true;
    displayManager.defaultSession = "none+i3";
    displayManager.lightdm = {
      enable = true;
      greeter.enable = true;
    };
    displayManager.autoLogin.enable = false;
  };

  # pipewire and wireplumber are for screen sharing
  # services.pipewire = {
  #   enable = true;
  #   wireplumber = {
  #     enable = true;
  #   };
  # };

  # xdg.portal = {
  #   enable = true;
  #   extraPortals = with pkgs; [
  #     xdg-desktop-portal-hyprland
  #   ];
  #   # gtkUsePortal = true;
  # };

  system.stateVersion = "23.11";
}
