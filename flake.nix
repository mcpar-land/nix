{
  description = "this is my configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
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
    agenix = {
      url = "github:ryantm/agenix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    rust-overlay,
    helix,
    agenix,
    ...
  }: let
    theme = (import ./theme.nix) {pkgs = nixpkgs;};
    monitor-list = monitors: {
      home-manager.extraSpecialArgs.monitor-list = monitors;
    };
    discs = discs: {
      home-manager.extraSpecialArgs.discs = discs;
    };
    # shared system config across all devices
    sharedSystemConfig = [
      ({pkgs, ...}: {
        nixpkgs.overlays = [
          rust-overlay.overlays.default
          (final: prev: {
            j-ctl = import ./j-ctl {pkgs = final;};
            custom-rofi-menu = (import ./apps/custom-rofi-menu.nix) {pkgs = final;};
            unstable = nixpkgs-unstable.legacyPackages."x86_64-linux";
          })
        ];
      })
      home-manager.nixosModules.home-manager
      agenix.nixosModules.default
      ./configuration.nix
      ./apps/i3lock.nix
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.sc.imports = [agenix.homeManagerModules.default ./home.nix ./users/sc.nix];
        home-manager.users.mcp.imports = [agenix.homeManagerModules.default ./home.nix ./users/mcp.nix];
        home-manager.extraSpecialArgs = {
          inherit theme;
          helix-master = helix;
          agenix = agenix;
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
          (discs [
            {
              path = "/";
              label = "/";
            }
            {
              path = "/mnt/attic";
              label = "attic";
            }
          ])
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
          (discs [
            {
              path = "/";
              label = "/";
            }
          ])
        ]
        ++ sharedSystemConfig;
    };
  };
}
