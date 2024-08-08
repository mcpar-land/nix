# yoinked from the nixpkgs pob file
# https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/games/path-of-building/default.nix#L124
{
  stdenv,
  pkgs,
  lib,
}: let
  version = "2.47.3";
  data = stdenv.mkDerivation (finalAttrs: {
    pname = "path-of-building-data";
    version = version;

    src = pkgs.fetchFromGitHub {
      owner = "PathOfBuildingCommunity";
      repo = "PathOfBuilding";
      rev = "v${version}";
      hash = "sha256-wxsU178BrjdeBTTPY2C3REWlyORWI+/fFijn5oa2Gms=";
    };

    nativeBuildInputs = [pkgs.unzip];

    buildCommand = ''
      unzip -j -d $out $src/runtime-win32.zip lua/sha1.lua
      cp -r $src/src $src/runtime/lua/*.lua $src/manifest.xml $out
      substituteInPlace $out/manifest.xml --replace '<Version' '<Version platform="nixos"'
      touch $out/installed.cfg
      chmod +w $out/src/UpdateCheck.lua
      echo 'return "none"' > $out/src/UpdateCheck.lua
    '';
  });
in
  stdenv.mkDerivation {
    pname = "path-of-building";
    version = version;
    src = pkgs.fetchFromGitHub {
      owner = "ernstp";
      repo = "pobfrontend";
      rev = "9faa19aa362f975737169824c1578d5011487c18";
      hash = "sha256-zhw2PZ6ZNMgZ2hG+a6AcYBkeg7kbBHNc2eSt4if17Wk=";
    };
    nativeBuildInputs = with pkgs; [
      meson
      ninja
      pkg-config
      kdePackages.qttools
      kdePackages.wrapQtAppsHook
      icoutils
      copyDesktopItems
    ];
    buildInputs = with pkgs; [
      kdePackages.qtbase
      luajit
      luajit.pkgs.lua-curl
    ];
    installPhase = ''
      runHook preInstall
      install -Dm555 pobfrontend $out/bin/pobfrontend

      wrestool -x -t 14 ${data.src}/runtime/Path{space}of{space}Building.exe -o pathofbuilding.ico
      icotool -x pathofbuilding.ico

      for size in 16 32 48 256; do
        mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
        install -Dm 644 pathofbuilding*"$size"x"$size"*.png \
          $out/share/icons/hicolor/"$size"x"$size"/apps/pathofbuilding.png
      done
      rm pathofbuilding.ico

      runHook postInstall
    '';
    preFixup = ''
      qtWrapperArgs+=(
        --set LUA_PATH "$LUA_PATH"
        --set LUA_CPATH "$LUA_CPATH"
        --chdir "${data}"
      )
    '';
    desktopItems = [
      (pkgs.makeDesktopItem {
        name = "path-of-building";
        desktopName = "Path of Building";
        comment = "Offline build planner for Path of Exile";
        exec = "pobfrontend %U";
        terminal = false;
        type = "Application";
        icon = "pathofbuilding";
        categories = ["Game"];
        keywords = [
          "poe"
          "pob"
          "pobc"
          "path"
          "exile"
        ];
        mimeTypes = ["x-scheme-handler/pob"];
      })
    ];
    passthru.data = data;
  }
