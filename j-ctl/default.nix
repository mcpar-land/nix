{pkgs ? import <nixpkgs> {}}:
pkgs.buildGoModule {
  pname = "j-ctl";
  version = "0.0.1";
  src = ./.;

  vendorHash = "sha256-17JDKKPJDlXupTl7UhuQkNGYsIIrO+/LxKWDUhfWp60=";
  postInstall = ''
    mv $out/bin/nix $out/bin/j-ctl
  '';
}
