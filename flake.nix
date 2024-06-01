{
  description = "this is my configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs-unstable";
      };
    };
    helix = {
      url = "github:helix-editor/helix";
      inputs = {
        nixpkgs.follows = "nixpkgs-unstable";
        rust-overlay.follows = "rust-overlay";
      };
    };
    eww = {
      url = "github:elkowar/eww";
      inputs = {
        nixpkgs.follows = "nixpkgs-unstable";
        rust-overlay.follows = "rust-overlay";
      };
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    rust-overlay,
    helix,
    eww,
    ...
  }: let
    theme = (import ./theme.nix) {pkgs = nixpkgs;};
    monitor-list = monitors: {
      home-manager.extraSpecialArgs.monitor-list = monitors;
    };
    # shared system config across all devices
    sharedSystemConfig = [
      ({pkgs, ...}: {
        nixpkgs.overlays = [
          rust-overlay.overlays.default
          (final: prev: {
            j-ctl = import ./j-ctl {pkgs = final;};
            custom-rofi-menu = (import ./apps/custom-rofi-menu.nix) {pkgs = final;};
          })
        ];
        environment.systemPackages = [
          (pkgs.rust-bin.stable.latest.default.override {
            extensions = ["rust-analyzer" "clippy" "rust-src"];
          })
        ];
      })
      home-manager.nixosModules.home-manager
      ./configuration.nix
      ./apps/i3lock.nix
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.sc.imports = [./home.nix ./users/sc.nix];
        home-manager.users.mcp.imports = [./home.nix ./users/mcp.nix];
        home-manager.extraSpecialArgs = {
          inherit theme;
          helix-master = helix;
          eww-master = eww;
        };
      }
    ];
  in {
    system.autoUpgrade = {
      enable = true;
      flake = inputs.self.outPath;
      flags = [
        "--update-input"
        "nixpkgs"
        "-L"
      ];
    };
    nixosConfigurations.j-desktop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules =
        [
          ./hardware/j-desktop.nix
          ((import ./apps/pipewire.nix) {
            outputDeviceId = "alsa_output.usb-SteelSeries_Arctis_7_-00.analog-stereo";
            inputDeviceId = "alsa_input.usb-SteelSeries_Arctis_7_-00.mono-fallback";
          })
          (monitor-list ["HDMI-A-0" "DisplayPort-1" "DisplayPort-2"])
        ]
        ++ sharedSystemConfig;
    };
    nixosConfigurations.j-laptop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules =
        [
          ./hardware/j-laptop.nix
          ((import ./apps/pipewire.nix) {
            outputDeviceId = "alsa_output.pci-0000_00_1f.3.analog-stereo";
            inputDeviceId = "alsa_input.pci-0000_00_1f.3.analog-stereo";
          })
          (monitor-list ["DP-1-1" "eDP-1" "DP-1-2"])
        ]
        ++ sharedSystemConfig;
    };
  };
}
