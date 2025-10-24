{pkgs ? import <nixpkgs> {}}:
pkgs.buildGoModule {
  pname = "j-ctl";
  version = "0.0.1";
  src = ./.;

  vendorHash = "sha256-S2hSMlSFbwU5LZcPSTmIx0Zf7q+VGDTR1ReDWgrC/BM=";
  postInstall = ''
    mv $out/bin/nix $out/bin/j-ctl
  '';
}
