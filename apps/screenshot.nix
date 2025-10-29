{pkgs, ...}: let
  sattyConfig = (pkgs.formats.toml {}).generate "satty" {
    general = {
      fullscreen = true;
      early-exit = true;
      initial-tool = "crop";
      save-after-copy = false;
      disable-notifications = false;
      action-on-enter = "save-to-clipboard";
      copy-command = "${pkgs.wl-clipboard}/bin/wl-copy";
    };
  };
  screenshot = pkgs.writeShellScriptBin "screenshot" ''
    CURRENT_MONITOR=$(swaymsg -t get_outputs | jq -r '.[] | select(.focused==true).name')
    ${pkgs.grim}/bin/grim -o $CURRENT_MONITOR -t ppm - | ${pkgs.satty}/bin/satty -c ${sattyConfig} -f -
  '';
in {
  home.packages = [
    screenshot
  ];
}
