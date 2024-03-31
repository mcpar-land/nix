{
  pkgs,
  theme,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    jq
    eww
  ];

  home.file = {
    "./.config/eww" = {
      source = ../eww;
    };
    # https://github.com/xruifan/i3-eww/tree/master/scripts
    "./.config/ewwscripts/getactivews".text = ''
      #!/bin/sh
      i3-msg -t subscribe -m '{"type":"workspace"}' |
      while read -r _; do
        workspaces_info=$(i3-msg -t get_workspaces)
        active_workspaces=$(echo "$workspaces_info" | ${pkgs.jq}/bin/jq --unbuffered -r '[.[] | .name] | join(" ")')
        echo "$active_workspaces"
      done
    '';
    "./.config/ewwscripts/getfocusedws".text = ''
      #!/bin/sh
      i3-msg -t subscribe -m '{"type":"workspace"}' |
      while read -r _; do
        workspaces_info=$(i3-msg -t get_workspaces)
        focused_workspaces=$(echo "$workspaces_info" | ${pkgs.jq}/bin/jq --unbuffered -r '.[] | select(.focused == true).name')
        echo "$focused_workspaces"
      done
    '';
    "./.config/ewwscripts/geturgentws".text = ''
      #!/bin/sh
      i3-msg -t subscribe -m '{"type":"workspace"}' |
      while read -r _; do
        workspaces_info=$(i3-msg -t get_workspaces)
        urgent_workspace=$(echo "$workspaces_info" | ${pkgs.jq}/bin/jq --unbuffered -r '.[] | select(.urgent == true).name')
        echo "$urgent_workspace"
      done
    '';
  };
}
