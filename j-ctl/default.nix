{pkgs ? import <nixpkgs> {}}:
pkgs.buildGoModule {
  pname = "j-ctl";
  version = "0.0.1";
  src = ./.;

  vendorHash = null;
  postInstall = ''
    mv $out/bin/nix $out/bin/j-ctl
  '';
}
