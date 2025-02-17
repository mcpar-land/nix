{pkgs, ...}: let
  version = "1.20.4";
  vintagestory = pkgs.unstable.vintagestory.overrideAttrs {
    inherit version;
    src = pkgs.fetchurl {
      url = "https://cdn.vintagestory.at/gamefiles/stable/vs_client_linux-x64_${version}.tar.gz";
      hash = "sha256-Hgp2u/y2uPnJhAmPpwof76/woFGz4ISUXU+FIRMjMuQ=";
    };
  };
in {
  home.packages = [
    vintagestory
  ];
}
