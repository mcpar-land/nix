{
  pkgs,
  theme,
  ...
}: {
  programs.zellij = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      on_force_close = "quit";
      pane_frames = false;
      theme = "monokai_pro";
      themes.monokai_pro = {
        fg = theme.base8.hex;
        bg = theme.base0.hex;
        black = theme.base0.hex;
        red = theme.red.hex;
        green = theme.green.hex;
        yellow = theme.yellow.hex;
        blue = theme.blue.hex;
        magenta = theme.magenta.hex;
        cyan = theme.cyan.hex;
        white = theme.base8.hex;
        orange = theme.orange.hex;
      };
    };
  };
}
