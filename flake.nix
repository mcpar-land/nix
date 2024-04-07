{
  description = "this is my configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # I like installing rust from the same source as helix
    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";
    helix.url = "github:helix-editor/helix";
    helix.inputs.rust-overlay.follows = "rust-overlay";
    helix.inputs.nixpkgs.follows = "nixpkgs";
    eww.url = "github:elkowar/eww";
    eww.inputs.rust-overlay.follows = "rust-overlay";
    eww.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-stable,
    home-manager,
    rust-overlay,
    helix,
    eww,
    ...
  }: let
    theme = (import ./theme.nix) {pkgs = nixpkgs;};
    # I just did this in reverse:
    # https://discourse.nixos.org/t/use-unstable-version-for-some-packages/32880/4
    stableOverlay = final: _prev: {
      stable = import nixpkgs-stable {
        system = final.system;
        config.allowUnfree = true;
      };
    };
    # shared system config across all devices
    sharedSystemConfig = [
      ({pkgs, ...}: {
        nixpkgs.overlays = [rust-overlay.overlays.default stableOverlay];
        environment.systemPackages = [
          (pkgs.rust-bin.stable.latest.default.override {
            extensions = ["rust-analyzer" "clippy"];
          })
        ];
      })
      home-manager.nixosModules.home-manager
      ./configuration.nix
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
        ]
        ++ sharedSystemConfig;
    };
    nixosConfigurations.j-laptop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules =
        [
          ./hardware/j-laptop.nix
        ]
        ++ sharedSystemConfig;
    };
  };
}
