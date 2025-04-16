{
  description = "this is my configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
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
    devenv = {
      url = "github:cachix/devenv";
      inputs = {
        nixpkgs.follows = "nixpkgs";
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
    devenv,
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
            unstable = import nixpkgs-unstable {
              system = "x86_64-linux";
              config.allowUnfree = true;
              config.permittedInsecurePackages = [
                # this is for vintage story
                "dotnet-runtime-7.0.20"
              ];
            };
            devenv = devenv.packages.${final.system}.default;
            helix = helix.packages.${final.system}.default;
            agenix = agenix.packages.${final.system}.default;
          })
        ];
      })
      home-manager.nixosModules.home-manager
      agenix.nixosModules.default
      ./configuration.nix
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.sc.imports = [agenix.homeManagerModules.default ./home.nix ./users/sc.nix];
        home-manager.users.mcp.imports = [agenix.homeManagerModules.default ./home.nix ./users/mcp.nix];
        home-manager.extraSpecialArgs = {
          inherit theme;
        };
      }
    ];
    systemNameOverlay = systemName: {
      home-manager.extraSpecialArgs.system-name = systemName;
    };
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
          (systemNameOverlay "j-desktop")
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
          (systemNameOverlay "j-laptop")
        ]
        ++ sharedSystemConfig;
    };
  };
}
