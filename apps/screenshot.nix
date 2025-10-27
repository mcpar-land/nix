{pkgs, ...}: let
  sattyConfig = (pkgs.formats.toml {}).generate "satty" {
    general = {
      fullscreen = false;
      early-exit = true;
      initial-tool = "arrow";
      save-after-copy = false;
      disable-notifications = false;
      action-on-enter = "save-to-clipboard";
      copy-command = "${pkgs.wl-clipboard}/bin/wl-copy";
    };
  };
  screenshot = pkgs.writeShellScriptBin "screenshot" ''
    ${pkgs.grim}/bin/grim -t ppm -g "$(${pkgs.slurp}/bin/slurp -d)" - | \
      ${pkgs.satty}/bin/satty -c ${sattyConfig} -f -
  '';
in {
  home.packages = [
    screenshot
  ];
}
