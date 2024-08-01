{pkgs, ...}: let
  version = "3.25.101";
in
  pkgs.appimageTools.wrapType2 {
    pname = "awakened-poe-trade";
    inherit version;
    src = pkgs.fetchurl {
      url = "https://github.com/SnosMe/awakened-poe-trade/releases/download/v${version}/Awakened-PoE-Trade-${version}.AppImage";
      hash = "sha256-n/lv+sA9f0IeQ9ntgzemEAzO9GMN08u/GXqPAzmiqK4=";
    };
  }
