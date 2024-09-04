{
  lib,
  stdenv,
  fetchurl,
  fetchzip,
  buildFHSEnv,
  makeDesktopItem,
}: let
  pname = "inky";
  version = "0.15.1";
  description = "An editor for the ink interactive narrative markup language";
  desktopItem = let
    icon = fetchurl {
      url = "https://raw.githubusercontent.com/inkle/inky/${version}/resources/Icon1024.png";
      hash = "sha256-82+s7MZ8a/GGPeNVZMlbC7n1IVpgqSO/xPYrtXaEIOs=";
    };
  in
    makeDesktopItem {
      name = "Inky";
      exec = "inky";
      icon = icon;
      desktopName = "Inky";
      comment = description;
      categories = ["Development" "IDE"];
    };
  inky = let
    src = fetchzip {
      url = "https://github.com/inkle/inky/releases/download/${version}/Inky_linux.zip";
      stripRoot = false;
      hash = "sha256-Ak4MQRb20R2VaEiXP214bvswe1DRvf6caPCdEw5FEKc=";
    };
  in
    stdenv.mkDerivation {
      inherit pname version src;
      dontConfigure = true;
      dontBuild = true;
      installPhase = ''
        runHook preInstall
        mkdir -p $out/bin $out/opt/inky
        chmod 755 Inky
        mv ./* $out/opt/inky
        ln -s $out/opt/inky/Inky $out/bin/Inky
        runHook postInstall
      '';
    };
in
  buildFHSEnv {
    inherit pname version;

    targetPkgs = pkgs:
      with pkgs; [
        inky
        udev
        icu
        zlib
        alsa-lib
        atk
        cairo
        cups
        dbus
        expat
        gdk-pixbuf
        glib
        gtk3
        libuuid
        libdrm
        mesa
        libxkbcommon
        nspr
        nss
        pango
        xorg.libX11
        xorg.libXScrnSaver
        xorg.libXcomposite
        xorg.libXcursor
        xorg.libXdamage
        xorg.libXext
        xorg.libXfixes
        xorg.libXi
        xorg.libXrandr
        xorg.libXrender
        xorg.libXtst
        xorg.libxcb
      ];
    runScript = "Inky $*";

    extraInstallCommands = ''
      mkdir -p "$out/share/applications"
      ln -s ${desktopItem}/share/applications/* "$out/share/applications"
    '';

    meta = {
      inherit description;
      mainProgram = "inky";
      homepage = "https://github.com/inkle/inky";
      license = lib.licenses.mit;
      platforms = ["x86_64-linux"];
    };
  }
