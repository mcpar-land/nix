{
  pkgs,
  theme,
  is-zfs,
  ...
}: {
  programs.waybar.enable = true;
  programs.waybar.systemd = {
    enable = true;
    target = "sway-session.target";
  };
  programs.waybar.settings = {
    mainBar = {
      modules-left = [
        "custom/bracket-left"
        "sway/workspaces"
        "custom/bracket-right"
        "custom/mediacontrol"
      ];
      modules-center = [
        "custom/bracket-left"
        "clock"
        "custom/weather"
        "keyboard-state"
        "custom/bracket-right"
      ];
      modules-right = [
        "custom/bracket-left"
        "network"
        (
          if is-zfs
          then "custom/zfs-disk"
          else "disk"
        )
        "cpu"
        "memory"
        "temperature"
        "battery"
        "custom/bracket-right"
        "tray"
      ];
      clock = {
        format = "{:%Y-%m-%d %OI:%M %p}";
        tooltip-format = "<tt>{calendar}</tt>";
        calendar = {
          mode = "year";
          mode-mon-col = 4;
          week-pos = "right";
          on-scroll = 1;
          format = {
            months = "<span color='${theme.base8.hex}'><b>{}</b></span>";
            days = "<span color='${theme.base8.hex}'>{}</span>";
            weeks = "<span color='${theme.base8.hex}'><b>W{}</b></span>";
            weekdays = "<span color='${theme.yellow.hex}'><b>{}</b></span>";
            today = "<span color='${theme.base0.hex}' background='${theme.green.hex}'><b>{}</b></span>";
          };
        };
      };
      cpu = {
        format = " {usage}%";
        on-click = "wezterm -e btop";
      };
      disk = {
        format = "󰋊 {used}/{total}";
      };
      "custom/zfs-disk" = {
        exec = pkgs.writeShellScript "zfs-disk" ''
          TOTAL="$(zpool get -Hp -o value size zpool | numfmt --to=iec)"
          USED="$(zpool get -Hp -o value allocated zpool | numfmt --to=iec)"
          echo $USED/$TOTAL
        '';
        format = "󰋊 {text}";
      };
      keyboard-state = {
        numlock = false;
        capslock = true;
        scrollock = false;
        format.capslock = "{icon}";
        format-icons = {
          locked = "CAPS";
          unlocked = "";
        };
      };
      memory = {
        interval = 10;
        format = " {used:0.1f}/{total:0.1f}G";
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
      temperature = {
        format = " {temperatureC}°C";
      };
      "sway/workspaces" = {
        disable-scroll = true;
        format = "{name}";
      };
      "custom/mediacontrol" = {
        format = " {}";
        escape = true;
        tooltip = false;
        exec = "playerctl metadata --format='{{ artist }} - {{ title }}' --follow";
        on-click = "playerctl play-pause";
        max-length = 50;
      };
      tray = {
        icon-size = 21;
        spacing = 10;
      };
      "custom/weather" = let
        location = "Cambridge+Massachusetts";
      in {
        format = "{}";
        interval = 60 * 10;
        escape = false;
        tooltip = true;
        exec = "j-ctl weather ${location}";
        return-type = "json";
      };
      "custom/bracket-left" = {
        format = "[";
        tooltip = false;
      };
      "custom/bracket-right" = {
        format = "]";
        tooltip = false;
      };
    };
  };
  programs.waybar.style =
    # css
    ''
      * {
        font-family: "GohuFont uni14 Nerd Font";
        font-size: 14px;
        border: none;
        border-radius: 0;
      }

      #waybar {
        background: ${theme.base1.hex};
        color: ${theme.base8.hex};
        margin: 0px;
        font-weight: 500;
      }

      tooltip {
        background: ${theme.base0.hex};
      }

      .module {
        background: ${theme.base1.hex};
        padding: 0 0.5em;
        transition: background-color 0.2s ease-in-out, color 0.2s ease-in-out;
      }
      .module:hover {
        background: ${theme.base3.hex};
      }

      #battery.charging {
        color: ${theme.green.hex};
      }

      #battery.warning:not(.charging) {
        color: ${theme.red.hex};
      }

      #clock {
        color: ${theme.magenta.hex};
      }

      #network.disconnected {
        color: ${theme.base5.hex};
      }

      #workspaces {
        padding: 0 0.25em;
      }

      #workspaces:hover {
        background: ${theme.base1.hex};
      }

      #workspaces button {
      	padding: 0 0.25em;
      }
      #workspaces button.focused {
        background: ${theme.blue.hex};
      	color: ${theme.base0.hex};
      }
      #workspaces button:hover {
      	box-shadow: inherit;
      	text-shadow: inherit;
      }
      #workspaces button:not(.focused):hover {
      	background: ${theme.base3.hex};
      }
      #workspaces button.urgent {
        background: ${theme.red.hex};
      }

      #keyboard-state {
        padding: 0;
        color: ${theme.orange.hex};
      }
      #keyboard-state label.locked {
        padding: 0 0.5em;
      }

      #custom-bracket-left, #custom-bracket-right {
        color: ${theme.base4.hex};
        background: transparent;
        padding: 0;
        margin: 0;
      }

      #custom-bracket-left:hover, #custom-bracket-right:hover {
        background: transparent;
      }

    '';
}
