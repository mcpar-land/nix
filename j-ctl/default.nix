{pkgs ? import <nixpkgs> {}}:
pkgs.buildGoModule {
  pname = "j-ctl";
  version = "0.0.1";
  src = ./.;

  vendorHash = "sha256-Fhm4Pocth6dmqt+1vnsZL6LlGkTMh2MJ9Ktl/duX59E=";
  postInstall = ''
    mv $out/bin/nix $out/bin/j-ctl
  '';
}
