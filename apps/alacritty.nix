{
  pkgs,
  theme,
  ...
}: {
  home.file."./.config/alacritty/alacritty.toml".source =
    (pkgs.formats.toml {}).generate "alacritty"
    {
      window = {
        padding = {
          x = 8;
          y = 8;
        };
        decorations = "None";
        opacity = 0.75;
        blur = true;
      };
      shell = {
        program = "zsh";
        args = [
          "--login"
          "-c"
          "zellij"
        ];
      };
      font = {
        normal = {
          family = "FiraCode Nerd Font Mono";
          style = "Regular";
        };
        bold = {
          family = "FiraCode Nerd Font Mono";
          style = "Bold";
        };
        size = 10;
      };
      colors = {
        primary = {
          foreground = theme.base8.hex;
          background = theme.base0.hex;
        };
        normal = {
          black = theme.base0.hex;
          red = theme.red.hex;
          green = theme.green.hex;
          yellow = theme.yellow.hex;
          blue = theme.blue.hex;
          magenta = theme.magenta.hex;
          cyan = theme.cyan.hex;
          white = theme.base8.hex;
        };
      };
      env = {
        WINIT_X11_SCALE_FACTOR = "1";
      };
    };
}
