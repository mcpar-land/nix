{pkgs ? import <nixpkgs> {}}:
pkgs.buildGoModule {
  pname = "j-ctl";
  version = "0.0.1";
  src = ./.;

  vendorHash = "sha256-eKeUhS2puz6ALb+cQKl7+DGvm9Cl+miZAHX0imf9wdg=";
  postInstall = ''
    mv $out/bin/nix $out/bin/j-ctl
  '';
}
