{
  pkgs,
  theme,
  ...
}: let
  font = "FiraCode Nerd Font";
  color = "ffffffff";
  i3lockScript = pkgs.writeShellScriptBin "i3lock-styled" ''
    ${pkgs.i3lock-color}/bin/i3lock-color \
      --blur=12 \
      --ignore-empty-password \
      --clock \
      --time-font="${font}" --time-color=${color} \
      --date-font="${font}" --date-color=${color} \
      --layout-font="${font}" --layout-color=${color} \
      --verif-font="${font}" \
      --wrong-font="${font}" \
      --greeter-font="${font}" \
      --verif-text="" \
      --wrong-text="" \
      --noinput-text=""
  '';
in {
  environment.systemPackages = [
    i3lockScript
  ];
}
