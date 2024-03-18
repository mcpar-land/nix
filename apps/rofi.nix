{
  pkgs,
  config,
  theme,
  ...
}: {
  programs.rofi = {
    enable = true;
    font = "Fira Sans 14";
    terminal = "alacritty";
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
        width = mkLiteral "480";
        background-color = mkLiteral theme.base0.hex;
      };
      "mainbox" = {
        padding = mkLiteral "12px";
      };
      "inputbar" = {
        background-color = mkLiteral theme.base1.hex;
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
        placeholder = "Search";
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
        lines = mkLiteral "8";
        columns = mkLiteral "1";
        fixed-height = mkLiteral "false";
      };
      "element" = {
        padding = mkLiteral "8px 16px";
        spacing = mkLiteral "8px";
        border-radius = mkLiteral "16px";
      };
      "element normal.active" = {
        text-color = mkLiteral theme.base3.hex;
        background-color = mkLiteral theme.blue.hex;
      };
      "selement selected.normal" = {
        background-color = mkLiteral theme.blue.hex;
      };
      "selement selected.active" = {
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
