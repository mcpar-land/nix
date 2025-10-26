{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  # copied verbatim from /etc/nixos/hardware-configuration.nix
  imports = [
    # ../configuration-remote-builds.nix
  ];

  home-manager.users.sc.imports = [./j-laptop-home.nix];
  home-manager.users.mcp.imports = [./j-laptop-home.nix];

  environment.systemPackages = with pkgs; [
  ];

  hardware.enableRedistributableFirmware = true;

  networking.hostName = "j-laptop";

  services.fwupd.enable = true;

  services.libinput.touchpad = {
    clickMethod = "clickfinger";
    tapping = false;
    scrollMethod = "twofinger";
    disableWhileTyping = true;
    naturalScrolling = true;
  };

  # brightness and volume controls on keyboard
  # programs.light = {
  #   enable = true;
  #   brightnessKeys.enable = true;
  # };

  # ===== everything past this line was copied verbatim from /etc/nixos/configuration.nixos

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  # never tried this, just added as a comment for later testing
  # https://wiki.nixos.org/wiki/NetworkManager
  # networking.networkmanager.wifi.powersave = true;

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

  # ===== everything past this line was copied verbatim from /etc/nixos/hardware-configuration.nixos
  boot.initrd.availableKernelModules = ["xhci_pci" "nvme" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/b968aa3e-6bf8-4fef-a01e-d14988ee802a";
    fsType = "ext4";
  };

  boot.initrd.luks.devices."luks-59766b16-0151-4d95-9d71-d99bd191905c".device = "/dev/disk/by-uuid/59766b16-0151-4d95-9d71-d99bd191905c";

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/5C4D-A58F";
    fsType = "vfat";
    options = ["fmask=0077" "dmask=0077"];
  };

  swapDevices = [
    {
      device = "/swapfile";
      size = 16 * 1024;
    }
  ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp0s20f3.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  system.stateVersion = "25.05";
}
