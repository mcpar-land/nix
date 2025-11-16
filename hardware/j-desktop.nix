{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ../configuration-remote-builds.nix
  ];

  home-manager.users.sc.imports = [./j-desktop-home.nix];
  home-manager.users.mcp.imports = [./j-desktop-home.nix];

  environment.systemPackages = with pkgs; [
    headsetcontrol # for steelseries headset
    gparted
    solaar # for logitech mouse
    radeontop # view amd gpu usage
  ];

  services.udev.packages = [pkgs.headsetcontrol];

  # for tekken?
  environment.etc.hosts = lib.mkForce {
    enable = true;
    user = "root";
    group = "root";
    text = ''
      127.0.0.1 localhost
      ::1 localhost
    '';
  };

  services.libinput.mouse = {
    middleEmulation = false;
  };

  boot.kernelParams = [
    "amdgpu.gpu_recovery=1"
  ];
  boot.loader.systemd-boot.memtest86.enable = true;
  boot.initrd.kernelModules = ["amdgpu"];
  services.xserver.videoDrivers = ["amdgpu"];
  hardware.graphics.enable = true;

  environment.sessionVariables = {
    # this is a fix for electron apps to make them run in wayland i think
    # NIXOS_OZONE_WL = "1";
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "j-desktop"; # Define your hostname.
  networking.hostId = "5346fadc"; # needed for zfs, but i'm not fully sure why.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod"];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];

  # recommended?
  services.zfs.autoScrub.enable = true;

  fileSystems."/" = {
    device = "zpool/root";
    fsType = "zfs";
    options = ["zfsutil"];
  };

  fileSystems."/nix" = {
    device = "zpool/nix";
    fsType = "zfs";
    options = ["zfsutil"];
  };

  fileSystems."/boot" = {
    device = "/dev/nvme0n1p1";
    fsType = "vfat";
  };

  fileSystems."/var" = {
    device = "zpool/enc/var";
    fsType = "zfs";
    options = ["zfsutil"];
  };

  fileSystems."/home" = {
    device = "zpool/enc/home";
    fsType = "zfs";
    options = ["zfsutil"];
  };

  swapDevices = [
    {
      device = "/dev/nvme0n1p2";
      randomEncryption = true;
    }
  ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno1.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  system.stateVersion = "24.11";
}
