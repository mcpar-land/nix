{pkgs ? import <nixpkgs> {}}:
pkgs.buildGoModule {
  pname = "j-ctl";
  version = "0.0.1";
  src = ./.;

  vendorHash = "sha256-S9e7CE6w8ov3EkJ0mQAtWv3PGpnb8kd/tqjekrdXQkI=";
  postInstall = ''
    mv $out/bin/nix $out/bin/j-ctl
  '';
}
