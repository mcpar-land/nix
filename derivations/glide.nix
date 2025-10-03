{pkgs ? import <nixpkgs> {}}: let
  version = "0.1.51a";
  extraLibs = with pkgs; [
    udev
    libva
    mesa
    libnotify
    xorg.libXScrnSaver
    cups
    alsa-lib
  ];
in
  pkgs.stdenv.mkDerivation {
    pname = "glide";
    version = version;

    src = pkgs.fetchzip {
      url = "https://github.com/glide-browser/glide/releases/download/${version}/glide.linux-x86_64.tar.xz";
      hash = "sha256-bn7xyUU85iiDQ3tA9cHI+PftFP2g3YqxDNsm2P4R/VQ=";
    };

    nativeBuildInputs = [
      pkgs.autoPatchelfHook
      pkgs.makeWrapper
    ];
    buildInputs = with pkgs; [
      stdenv.cc.cc.lib
      xorg.libX11
      gtk3
      alsa-lib
      gvfs
    ];
    # autoPatchelfIgnoreMissingDeps = true;

    libs = pkgs.lib.makeLibraryPath extraLibs;

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin
      mkdir -p $out/lib
      makeWrapper $src/glide $out/bin/glide \
        --prefix LD_LIBRARY_PATH ":" $libs
      cp $src/glide $out/bin/
      cp $src/glide-bin $out/bin/
      cp $src/crashreporter $out/bin/
      cp $src/crashhelper $out/bin/
      cp -r $src/browser $out/bin/
      cp -r $src/defaults $out/bin/
      cp -r $src/fonts $out/bin/
      cp -r $src/gmp-clearkey $out/bin/
      cp $src/*.so $out/lib/
      runHook postInstall
    '';
  }
