{
  pkgs,
  theme,
  lib,
  eww-master,
  monitor-list,
  ...
}: {
  home.packages = with pkgs; [
    jq
    eww-master.packages.${pkgs.system}.default
    wmctrl
    playerctl
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
    "./.config/ewwscripts/launch" = {
      text = ''
        eww kill
        eww open topbar --id topbar0 --screen 0 --arg "primary=true"
        eww open topbar --id topbar1 --screen 1 --arg "primary=false"
        eww open topbar --id topbar2 --screen 2 --arg "primary=false"
      '';
      executable = true;
    };
    "./.config/ewwscripts/weather" = {
      text = ''curl "wttr.in?format=%C%20%t" 2> /dev/null | sed "s/\+//g"'';
      executable = true;
    };
    "./.config/ewwscripts/wslist" = {
      text = ''
        wslist_json() {
          CURRENT_WORKSPACES=$(i3-msg -t get_workspaces | jq '[group_by(.output)[] | {(.[0].output): [.[]]}] | add')
          OUTPUTS_IN_ORDER='${builtins.toJSON monitor-list}'
          echo $OUTPUTS_IN_ORDER | jq -Mc --unbuffered --argjson ws "$CURRENT_WORKSPACES" 'map($ws[.]) | map([null, .]) | flatten | .[1:]'
        }
        wslist_json
        i3-msg -t subscribe -m '{"type":"workspace"}' |
        while read -r _; do
          wslist_json
        done
      '';
      executable = true;
    };
    "./.config/ewwscripts/battery_level" = {
      text = ''
        BAT=`ls /sys/class/power_supply | grep BAT | head -n 1`
        if [ ! -z "$BAT" ]; then
          cat /sys/class/power_supply/$BAT/capacity
        else
          echo "-1"
        fi
      '';
      executable = true;
    };
  };
}
