{
  pkgs,
  theme,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    jq
    eww
    wmctrl
  ];

  home.file = {
    "./.config/eww/eww.yuck" = {
      source = ../eww/eww.yuck;
      recursive = true;
    };
    "./.config/eww/eww.scss" = {
      source = ../eww/eww.scss;
      recursive = true;
    };
    "./.config/ewwscripts/theme.scss" = {
      text = ''
        $red: ${theme.red.hex};
        $orange: ${theme.orange.hex};
        $yellow: ${theme.yellow.hex};
        $green: ${theme.green.hex};
        $blue: ${theme.blue.hex};
        $magenta: ${theme.magenta.hex};
        $cyan: ${theme.cyan.hex};
        $base0: ${theme.base0.hex};
        $base1: ${theme.base1.hex};
        $base2: ${theme.base2.hex};
        $base3: ${theme.base3.hex};
        $base4: ${theme.base4.hex};
        $base5: ${theme.base5.hex};
        $base6: ${theme.base6.hex};
        $base7: ${theme.base7.hex};
        $base8: ${theme.base8.hex};

        $white: ${theme.white.hex};
        $black: ${theme.black.hex};

        $gap: ${toString theme.gap}px;
        $barHeight: ${toString theme.barHeight}px;
      '';
    };

    # https://github.com/xruifan/i3-eww/tree/master/scripts
    "./.config/ewwscripts/getworkspaces" = {
      text = ''
        #!/bin/sh
        export SELECTED_DISPLAY=$1
        print_workspaces_json() {
          i3-msg -t get_workspaces | ${pkgs.jq}/bin/jq -Mc --unbuffered '[ .[] | select(.output == env.SELECTED_DISPLAY) ]'
        }
        print_workspaces_json
        i3-msg -t subscribe -m '{"type":"workspace"}' |
        while read -r _; do
          print_workspaces_json
        done
      '';
      executable = true;
    };
  };
}
