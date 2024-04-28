{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  # copied verbatim from /etc/nixos/hardware-configuration.nix
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  environment.systemPackages = with pkgs; [
    headsetcontrol # for steelseries headset
    helvum # for pipewire
    gparted
  ];

  fileSystems."/mnt/attic" = {
    device = "/dev/disk/by-uuid/DE6ABA5E6ABA335F";
    options = ["nofail" "x-systemd.automount"];
    # options = ["nofail" "x-systemd.automount"];
  };

  boot.kernelParams = [
    "amdgpu.gpu_recovery=1"
  ];
  boot.initrd.kernelModules = ["amdgpu"];
  services.xserver.videoDrivers = ["amdgpu"];
  hardware.opengl = {
    enable = true;
    driSupport = true;
  };

  services.xserver.xrandrHeads = [
    "HDMI-A-0"
    {
      output = "DisplayPort-1";
      primary = true;
    }
    "DisplayPort-2"
  ];

  environment.sessionVariables = {
    # this is a fix for electron apps to make them run in wayland i think
    # NIXOS_OZONE_WL = "1";
  };

  # ===== everything past this line was copied verbatim from /etc/nixos/configuration.nixos

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "j-desktop"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = import ../apps/pipewire.nix {
    outputDeviceId = "alsa_output.usb-SteelSeries_Arctis_7_-00.analog-stereo";
  };

  # ===== everything past this line was copied verbatim from /etc/nixos/hardware-configuration.nixos
  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod"];
  # boot.initrd.kernelModules = []; # manually editing this further up
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/c65fcce6-f780-4fb9-82e8-9d5c8dafe3ec";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/D4A4-24E4";
    fsType = "vfat";
  };

  swapDevices = [];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno1.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
