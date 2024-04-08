{
  config,
  lib,
  pkgs,
  theme,
  ...
}: {
  home.packages = with pkgs; [
    libnotify
  ];

  # https://dunst-project.org/documentation/
  services.dunst = {
    enable = true;
    settings = {
      global = {
        width = 400;
        height = 100;
        offset = "${toString (theme.gap * 2)}x${toString (theme.barHeight + theme.gap * 2)}";
        origin = "top-right";
        # we only want the background to be transparent
        transparency = 0;
        font = "Fira Sans 10";
        frame_width = 1;
        separator_height = 1;
        corner_radius = theme.gap;
        icon_corner_radius = theme.gap;
        background = theme.base0.hexTransparent 0.75;
        foreground = theme.base8.hexTransparent 0.75;
        frame_color = theme.base6.hexTransparent 0.125;
        separator_color = theme.base6.hexTransparent 0.125;
        ellipsize = "end";
        fullscreen = "pushback";
        ignore_newline = true;
        mouse_left_click = "do_action";
        mouse_right_click = "close_all";
        mouse_middle_click = "context";
        dmenu = "${pkgs.rofi}/bin/rofi -dmenu -p dunst";
      };
    };
  };
}
