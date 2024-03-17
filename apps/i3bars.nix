{
  pkgs,
  theme,
  ...
}: let
  bar = {
    output,
    blocks,
    trayOutput ? "none",
  }: {
    position = "top";
    command = "i3bar";
    statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ${
      (pkgs.formats.toml {}).generate "i3status-rust.toml" {
        theme.overrides = {
          idle_bg = theme.base2.hex;
          idle_fg = theme.base8.hex;
          good_bg = theme.green.hex;
          good_fg = theme.base0.hex;
          warning_bg = theme.yellow.hex;
          warning_fg = theme.base0.hex;
          critical_bg = theme.red.hex;
          critical_fg = theme.base0.hex;
          info_bg = theme.blue.hex;
          info_fg = theme.base0.hex;
          alternating_tint_bg = theme.base3.hex;
          alternating_tint_fg = theme.base8.hex;
          separator = "󰇙";
          separator_bg = "auto";
          separator_fg = "auto";
        };
        icons.icons = "material-nf";
        block = blocks;
      }
    }";
    extraConfig = let
      # helper function for workspace colors
      ws = bg: fg: "${bg.hex} ${bg.hex} ${fg.hex}";
    in ''
      font pango:FiraCode Nerd Font Mono 14, Fira Sans 11
      padding 0px 0px 0px ${toString theme.gap}px
      output ${output}
      tray_output ${trayOutput}
      tray_padding 0
      colors {
        background ${theme.base0.hex}
        focused_background ${theme.base1.hex}
        inactive_workspace ${ws theme.base3 theme.base7}
        active_workspace ${ws theme.base6 theme.base0}
        focused_workspace ${ws theme.blue theme.base0}
        urgent_workspace ${ws theme.red theme.base0}
        binding_mode ${ws theme.magenta theme.base0}
      }
    '';
  };
  timeFormat = " $timestamp.datetime(f:'%a %m/%d %I:%M') ";
in {
  xsession.windowManager.i3.config.bars = [
    (bar {
      output = "primary";
      trayOutput = "primary";
      blocks = [
        {
          block = "docker";
        }
        {
          block = "disk_space";
        }
        {
          block = "cpu";
        }
        {
          block = "memory";
        }
        {
          block = "amd_gpu";
        }
        {
          block = "time";
          interval = 60;
          format = timeFormat;
        }
      ];
    })
    (bar {
      output = "nonprimary";
      blocks = [
        {
          block = "time";
          interval = 60;
          format = timeFormat;
        }
      ];
    })
  ];
}
