{
  pkgs,
  config,
  theme,
  ...
}: {
  programs.rofi = {
    enable = true;
    font = "Iosevka Custom 14";
    terminal = "wezterm";
    plugins = [
      pkgs.unstable.rofi-emoji
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
      };
      "window" = {
        location = mkLiteral "center";
        width = mkLiteral "750";
        background-color = mkLiteral (theme.base0.hexTransparent 0.5);
      };
      "mainbox" = {
        padding = mkLiteral "12px";
      };
      "inputbar" = {
        background-color = mkLiteral (theme.base1.hexTransparent 0.5);
        border-color = mkLiteral theme.base3.hex;
        border = mkLiteral "1px";
        border-radius = mkLiteral "8px";
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
        border-radius = mkLiteral "8px";
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
        columns = mkLiteral "2";
        fixed-height = mkLiteral "false";
      };
      "element" = {
        padding = mkLiteral "${toString theme.gap}px ${toString (theme.gap * 2)}px";
        spacing = mkLiteral "${toString theme.gap}px";
        border-radius = mkLiteral "${toString theme.gap}px";
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
