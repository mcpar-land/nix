{
  pkgs,
  config,
  theme,
  ...
}: let
  rofiLauncher = pkgs.writeShellScriptBin "rofi-launcher" ''
    # pkill rofi
    rofi -show combi \
      -modes combi \
      -combi-modes "window#drun#ssh" \
      -show-icons \
      -display-drun "" \
      -display-combi "" \
      -display-window "" \
      -window-thumbnail \
      -ssh-command "wezterm ssh {host}"
  '';
in {
  home.packages = [rofiLauncher];
  programs.rofi = {
    enable = true;
    # font = "GohuFont Regular 14";
    terminal = "wezterm";
    package = pkgs.rofi-wayland;
    plugins = [
      pkgs.rofi-emoji
    ];
    theme = let
      inherit (config.lib.formats.rasi) mkLiteral;
    in {
      "*" = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral theme.base8.hex;
        margin = mkLiteral "0px";
        padding = mkLiteral "0px";
        spacing = mkLiteral "0px";
        font = "GohuFont Regular ${toString 10.206}";
      };
      "window" = {
        location = mkLiteral "center";
        width = mkLiteral "100%";
        background-color = mkLiteral (theme.base0.hex);
        border = mkLiteral "4px 0px";
        border-color = mkLiteral theme.blue.hex;
      };
      "mainbox" = {
        padding = mkLiteral "12px";
      };
      "inputbar" = {
        background-color = mkLiteral (theme.base1.hex);
        border-color = mkLiteral theme.base3.hex;
        border = mkLiteral "1px";
        padding = mkLiteral "8px 16px";
        spacing = mkLiteral "8px";
        children = [(mkLiteral "prompt") (mkLiteral "entry")];
      };
      "prompt" = {
        text-color = mkLiteral theme.base8.hex;
      };
      "entry" = {
        placeholder = "=^ ovo^=";
        placeholder-color = mkLiteral theme.base7.hex;
      };
      "message" = {
        margin = mkLiteral "12px 0 0";
        border-color = mkLiteral theme.base2.hex;
        background-color = mkLiteral theme.base2.hex;
      };
      "textbox" = {
        padding = mkLiteral "8px 24px";
      };
      "listview" = {
        background-color = mkLiteral "transparent";
        margin = mkLiteral "12px 0 0";
        lines = mkLiteral "16";
        columns = mkLiteral "4";
        fixed-height = mkLiteral "false";
      };
      "element" = {
        padding = mkLiteral "${toString theme.gap}px ${toString (theme.gap * 2)}px";
        spacing = mkLiteral "${toString theme.gap}px";
      };
      "element normal.active" = {
        text-color = mkLiteral theme.base3.hex;
        background-color = mkLiteral theme.blue.hex;
      };
      "element selected.normal" = {
        text-color = mkLiteral theme.base0.hex;
        background-color = mkLiteral theme.blue.hex;
      };
      "element selected.active" = {
        text-color = mkLiteral theme.base0.hex;
        background-color = mkLiteral theme.blue.hex;
      };
      "element-icon" = {
        size = mkLiteral "1em";
        vertical-align = mkLiteral "0.5";
      };
      "element-text" = {
        text-color = mkLiteral "inherit";
      };
    };
  };
}
