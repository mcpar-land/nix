{pkgs, ...}: let
  version = "1.20.3";
  vintagestory = pkgs.unstable.vintagestory.overrideAttrs {
    inherit version;
    src = pkgs.fetchurl {
      url = "https://cdn.vintagestory.at/gamefiles/stable/vs_client_linux-x64_${version}.tar.gz";
      hash = "sha256-+nEyFlLfTAOmd8HrngZOD1rReaXCXX/ficE/PCLcewg=";
    };
  };
in {
  home.packages = [
    vintagestory
  ];
}
