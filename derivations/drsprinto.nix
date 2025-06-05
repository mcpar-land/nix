{
  fetchurl,
  appimageTools,
  ...
}: let
  pname = "drsprinto";
  version = "4.0.7";
  src = fetchurl {
    url = "https://static.sprinto.com/drsprinto/DrSprinto-${version}.AppImage";
    hash = "sha256-o6WYoA9qZYkl/H2WMhv/acNoiuTfIlbj78E0jK+SQG0=";
  };
  appimageContents = appimageTools.extract {
    inherit pname version src;
  };
in
  appimageTools.wrapType2 rec {
    inherit pname version src;

    extraPkgs = pkgs: [pkgs.lsb-release];

    extraInstallCommands = ''
      install -m 444 -D ${appimageContents}/drsprinto.desktop $out/share/applications/drsprinto.desktop
      install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/128x128/apps/drsprinto.png \
        $out/share/icons/hicolor/128x128/apps/drsprinto.png
      substituteInPlace $out/share/applications/drsprinto.desktop \
        --replace-fail 'Exec=AppRun --no-sandbox %U' 'Exec=${pname}'
    '';
  }
