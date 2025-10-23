{pkgs, ...}: {
  programs.waybar.enable = true;
  programs.waybar.systemd = {
    enable = true;
    target = "sway-session.target";
  };
  programs.waybar.settings = {
    mainBar = {
      modules-left = [
        "sway/workspaces"
        # "custom/right-arrow-dark"
      ];
      modules-center = [
        "clock"
      ];
      modules-right = [
        # "mpd"
        "pulseaudio"
        "network"
        "cpu"
        "memory"
        # "temperature"
        # "backlight"
        # "keyboard-state"
        "battery"
        "tray"
      ];
      clock = {
        format = "{:%Y-%m-%d %OI:%M %p}";
      };
      cpu = {
        format = "  {icon0}{icon1}{icon2}{icon3} {usage:>2}%";
        format-icons = ["▁" "▂" "▃" "▄" "▅" "▆" "▇" "█"];
        on-click = "wezterm -e btop";
      };
      keyboard-state = {
        numlock = false;
        capslock = true;
        scrollock = false;
      };
      memory = {
        interval = 10;
        format = " {used:0.1f}G/{total:0.1f}G";
        tooltip-format = "Memory";
      };
      network = {
        format-wifi = "󰤢 ";
        format-ethernet = "󰈀 ";
        format-disconnected = "󰤠 ";
        interval = 5;
        tooltip-format = "{essid} ({signalStrength}%)";
        on-click = "nm-connection-editor";
      };
      battery = {
        interval = 2;
        states = {
          warning = 20;
          critical = 10;
        };
        format = "{icon} {capacity}%";
        format-full = "{icon} {capacity}%";
        format-charging = " {capacity}%";
        format-plugged = " {capacity}%";
        format-alt = "{icon} {time}";
        format-icons = ["" "" "" "" ""];
      };
      "sway/workspaces" = {
        disable-scroll = true;
        format = "{name} {icon}";
        format-icons = {
          active = "";
          default = "";
        };
      };
      tray = {
        icon-size = 21;
        spacing = 10;
      };
      "custom/left-arrow-dark" = {
        format = "";
        tooltip = false;
      };
      "custom/left-arrow-light" = {
        format = "";
        tooltip = false;
      };
      "custom/right-arrow-dark" = {
        format = "";
        tooltip = false;
      };
      "custom/right-arrow-light" = {
        format = "";
        tooltip = false;
      };
    };
  };
  programs.waybar.style =
    # css
    ''
      * {
        font-family: "FiraCode Nerd Font Propo";
        font-size: 11pt;
        border: none;
        border-radius: 0;
      }

      #workspaces button {
      	padding: 0 2px;
      	color: #fdf6e3;
      }
      #workspaces button.focused {
      	color: #268bd2;
      }
      #workspaces button:hover {
      	box-shadow: inherit;
      	text-shadow: inherit;
      }
      #workspaces button:hover {
      	background: #1a1a1a;
      	border: #1a1a1a;
      	padding: 0 3px;
      }
    '';
}
