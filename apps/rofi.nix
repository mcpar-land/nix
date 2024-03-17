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
        background-color = mkLiteral theme.base0.hex;
        text-color = mkLiteral theme.base8.hex;
      };
    };
  };
}
