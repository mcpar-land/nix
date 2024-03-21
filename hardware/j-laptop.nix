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

  hardware.system76.enableAll = true;
  networking.hostName = "j-laptop";

  services.xserver.libinput.touchpad = {
    clickMethod = "clickfinger";
    tapping = false;
    scrollMethod = "twofinger";
    disableWhileTyping = true;
    naturalScrolling = true;
  };

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # ===== everything past this line was copied verbatim from /etc/nixos/configuration.nixos

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-c0e013cf-4f27-4cea-8b83-1091da8cb306".device = "/dev/disk/by-uuid/c0e013cf-4f27-4cea-8b83-1091da8cb306";

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

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
  boot.initrd.availableKernelModules = ["xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" "sdhci_pci"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/c2548abe-c1cd-4faa-906f-5644644ca173";
    fsType = "ext4";
  };

  boot.initrd.luks.devices."luks-24271811-9cee-4236-bfad-7492a733ce8e".device = "/dev/disk/by-uuid/24271811-9cee-4236-bfad-7492a733ce8e";

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/0701-9618";
    fsType = "vfat";
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/454705d4-e823-40e2-b43b-0fbe4f301d36";}
  ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp37s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp0s20f3.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
