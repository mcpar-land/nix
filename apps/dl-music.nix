{pkgs, ...}: let
  dl-music = pkgs.writeShellScriptBin "dl-music" ''
    set -e
    mkdir -p ~/dl-music
    yt-dlp \
      --paths ~/dl-music \
      --output "%(album_artists.0,album_artist,artists.0,artist)s/%(album)s/%(playlist_index)02d - %(track)s" \
      --format bestaudio/bestvideo \
      --extract-audio \
      --audio-format mp3 \
      --no-keep-video \
      --embed-metadata \
      --restrict-filenames \
      --parse-metadata "playlist_index:%(track_number)s" \
      --parse-metadata "description:(?P<release_date>\d{4}-\d{2}-\d{2})" \
      --concurrent-fragments 1 \
      --retry-sleep fragment:exp=1:20 \
      --min-sleep-interval 3 \
      --max-sleep-interval 10 \
      --abort-on-error \
      ''${1?missing playlist url}
    rsync -hr --progress \
      --usermap="*:nixos" \
      --groupmap="*:media" \
      --chmod 770 \
      ~/dl-music/ jamrock:/data/media/music/
  '';
in {
  home.packages = [
    dl-music
    pkgs.unstable.curl-impersonate
    pkgs.unstable.python313Packages.curl-cffi
  ];
}
