{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  environment.systemPackages = with pkgs; [
    headsetcontrol # for steelseries headset
    gparted
    solaar # for logitech mouse
    radeontop # view amd gpu usage
  ];

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

  services.autorandr = {
    enable = true;
    defaultTarget = "normal";
    hooks.postswitch = {};
    profiles."normal" = {
      fingerprint = {
        "DisplayPort-1" = "00ffffffffffff0004726e0a9b63814112220104b5371e783b0085a257549b210f5054bfef80714f81808140810081c09500b3000101023a801871382d40582c4500202e2100001a000000fd0c30faffff3f010a202020202020000000fc004b4732353151205a0a20202020000000ff003234313831363339423357303101a4020331f1480103049012139f3f23090705830100006d1a0000020130fa000000000000e200c0e305c301e6060501595900b3f1801871382d40582c4500202e2100001a21e7801871382642582c000b202e2100001a08e8801871389244582c000b202e2100001a08e8801871382d40582c4500202e2100001e00000000000014";
        "DisplayPort-2" = "00ffffffffffff003669b540000000002b210104a5351d783ab705ad564d99260d5054bfcf00714f81c0818081009500b300d1c00101023a801871382d40582c450012222100001e000000fc004d5349204d50323433580a2020000000fd0030645d5d21010a202020202020000000ff005042354834303341303033323801f202031e7448900102030412131f2309070783010000681a000001013064002a4480a0703827403020350012222100001aeb5a80a0703827403020350012222100001e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000070";
        "HDMI-A-0" = "00ffffffffffff0010ac4a42575a58411e1f010380351e78ea6785a854529f27125054a54b00714f8180a9c0d1c00101010101010101023a801871382d40582c45000f282100001e000000ff0037435a365938330a2020202020000000fc0044454c4c20534532343232480a000000fd00304b1e5312000a202020202020013e02031fb14b9005141f0413121103020165030c001000681a00000101304b002a4480a070382740302035000f282100001a011d8018711c1620582c25000f282100009e011d007251d01e206e2855000f282100001e8c0ad08a20e02d10103e96000f2821000018000000000000000000000000000000000000000000000000d8";
      };
      config = {
        "HDMI-A-0" = {
          mode = "1920x1080";
          position = "0x0";
          rate = "60.00";
        };
        "DisplayPort-1" = {
          mode = "1920x1080";
          position = "1920x0";
          rate = "60.00";
          primary = true;
        };
        "DisplayPort-2" = {
          mode = "1920x1080";
          position = "3840x0";
          rate = "60.0";
        };
      };
    };
  };
  services.xserver.displayManager.setupCommands = ''
    ${pkgs.autorandr}/bin/autorandr ${config.services.autorandr.defaultTarget}
  '';

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
