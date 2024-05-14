{pkgs, ...}:
pkgs.stdenv.mkDerivation {
  name = "berkeley-mono";
  version = "latest";
  srcs = [
    ./BerkeleyMonoTrial-Regular.ttf
  ];
  phases = ["installPhase"];
  installPhase = ''
    mkdir -p $out/share/fonts/truetype/berkeley-mono
    cp ${./BerkeleyMonoTrial-Regular.ttf} $out/share/fonts/truetype/berkeley-mono
  '';
}
