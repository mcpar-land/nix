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
    system76-keyboard-configurator
  ];

  powerManagement.powertop.enable = true;

  services.autorandr = {
    enable = true;
    defaultTarget = "nothing_plugged_in";
    hooks.postswitch = {
    };
    profiles."nothing_plugged_in" = {
      fingerprint = {
        "eDP-1" = "00ffffffffffff000dae121500000000301d0104a52213780328659759548e271e505400000001010101010101010101010101010101363680a0703820403020a50058c110000018000000fe004e3135364843412d4535420a20000000fe00434d4e0a202020202020202020000000fe004e3135364843412d4535420a2000c7";
      };
      config = {
        "eDP-1" = {
          primary = true;
          mode = "1920x1080";
          rate = "60.0";
        };
      };
    };
    profiles."office" = {
      fingerprint = {
        "DP-1-1" = "00ffffffffffff0004726f049d509003271e010380351e78ee0565a756529c270f5054b30c00714f818081c081009500b300d1c00101023a801871382d40582c45000f282100001e000000fd00384b1f4b12000a202020202020000000fc005232343048590a202020202020000000ff005434424141303031323431310a01e202031cf1499001030412131f0514230907078301000065030c001000023a801871382d40582c45000f282100001e011d007251d01e206e2855000f282100001e8c0ad08a20e02d10103e96000f2821000018d60980a020e02d10086022000f28210808180000000000000000000000000000000000000000000000000000002e";
        "DP-1-2" = "00ffffffffffff0004726f04de0f9014311f010380351e78ee0565a756529c270f5054b30c00714f818081c081009500b300d1c00101023a801871382d40582c45000f282100001e000000fd00384b1f4b12000a202020202020000000fc005232343048590a202020202020000000ff005434424141303031323431310a01c602031cf1499001030412131f0514230907078301000065030c001000023a801871382d40582c45000f282100001e011d007251d01e206e2855000f282100001e8c0ad08a20e02d10103e96000f2821000018d60980a020e02d10086022000f28210808180000000000000000000000000000000000000000000000000000002e";
        "eDP-1" = "00ffffffffffff000dae121500000000301d0104a52213780328659759548e271e505400000001010101010101010101010101010101363680a0703820403020a50058c110000018000000fe004e3135364843412d4535420a20000000fe00434d4e0a202020202020202020000000fe004e3135364843412d4535420a2000c7";
      };
      config = {
        "DP-1-1" = {
          mode = "1920x1080";
          position = "0x0";
          rate = "60.0";
        };
        "eDP-1" = {
          primary = true;
          mode = "1920x1080";
          position = "1920x0";
          rate = "60.0";
        };
        "DP-1-2" = {
          mode = "1920x1080";
          position = "3840x0";
          rate = "60.0";
        };
      };
    };
  };

  networking.hostName = "j-laptop";

  hardware.system76.enableAll = true;
  services.system76-scheduler = {
    enable = true;
    useStockConfig = true;
  };
  services.power-profiles-daemon.enable = false;

  services.libinput.touchpad = {
    clickMethod = "clickfinger";
    tapping = false;
    scrollMethod = "twofinger";
    disableWhileTyping = true;
    naturalScrolling = true;
  };

  # brightness and volume controls on keyboard
  programs.light = {
    enable = true;
    brightnessKeys.enable = true;
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

  system.stateVersion = "23.11";
}
