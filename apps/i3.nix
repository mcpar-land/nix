{
  pkgs,
  lib,
  theme,
  config,
  monitor-list,
  custom-rofi-menu,
  ...
}: let
  mod = "Mod4";
  sessionStart = pkgs.writeShellScript "i3-session" ''
    systemctl --user set-environment I3SOCK=$(${config.xsession.windowManager.i3.package}/bin/i3 --get-socketpath)
    systemctl --user start graphical-session-i3.target
    # needed to activate the keyring
    # https://wiki.archlinux.org/title/GNOME/Keyring#PAM_method
    dbus-update-activation-environment --all
    # why does services.libinput.mouse.middleEmulation = false not work??
    xinput set-prop "SteelSeries SteelSeries Rival 600" "libinput Middle Emulation Enabled" 0
  '';
  openRofi = pkgs.writeShellScript "open-rofi" ''
    pkill rofi
    rofi -show combi -combi-modes "window,drun,ssh" -show-icons -modes combi -display-drun "" -display-combi "" -display-window "" -window-thumbnail
  '';
  openRofiEmoji = pkgs.writeShellScript "open-rofi-emoji" ''
    rofi -modi emoji -show emoji -kb-custom-1 Ctrl+c -theme-str 'listview { columns: 6; } window { width: 1280px; }'
  '';
  i3SwitchCmd = offset: "exec --no-startup-id \"j-ctl i3 switch --displays \\\\\"${builtins.concatStringsSep "," monitor-list}\\\\\" --offset ${toString offset}\"";
  powermenu = pkgs.custom-rofi-menu "powermenu" {
    options = [
      {
        label = "Logout";
        exec = "loginctl terminate-session ''";
      }
      {
        label = "Lock";
        exec = "i3lock-styled";
      }
      {
        label = "Suspend";
        exec = "i3lock-styled && systemctl suspend";
      }
    ];
  };
in {
  home.packages = with pkgs; [
  ];

  services.picom = let
    effects-exclude = [
      "class_g = 'i3bar'"
      "window_type = 'menu'"
      "window_type = 'dropdown_menu'"
      "window_type = 'popup_menu'"
      "window_type = 'utility'"
      "window_type = 'dock'"
      "class_g = 'awakened-poe-trade'"
      "name = 'Annotation - Zoom'"
    ];
  in {
    enable = true;
    shadow = true;
    fade = false;
    vSync = true;
    settings = {
      blur = {
        method = "dual_kawase";
        size = 20;
        deviation = 5.0;
      };
      round-borders = 1;
      corner-radius = theme.gap;
      rounded-corners-exclude = effects-exclude;
      shadow-exclude = effects-exclude;
      blur-background-exclude = effects-exclude;
    };
    backend = "glx";
  };

  systemd.user.targets.graphical-session-i3 = {
    Unit = {
      Description = "i3 X session";
      BindsTo = ["graphical-session.target"];
      Requisite = ["graphical-session.target"];
    };
  };

  xsession.windowManager.i3.enable = true;
  xsession.windowManager.i3.extraConfig = ''
    exec --no-startup-id ${sessionStart}

    for_window [class="zoom"] floating enable
    for_window [class="zoom" title="Zoom - Licensed Account"] floating disable
    for_window [class="zoom" title="Zoom - Free Account"] floating disable
    for_window [class="zoom" title="Zoom Meeting"] floating disable
    for_window [class="zoom" title="Zoom Webinar"] floating disable
  '';
  xsession.windowManager.i3.config = {
    modifier = mod;
    terminal = "wezterm";
    gaps.inner = theme.gap;
    gaps.outer = 0;
    window.titlebar = false;
    window.border = 0;
    focus.followMouse = false;
    focus.mouseWarping = true;

    floating.criteria = [
      {class = "Pavucontrol";}
      {class = "term_btop";}
      {class = "simplescreenrecorder";}
      {class = "SimpleScreenRecorder";}
      {class = "awakened-poe-trade";}
    ];

    keybindings =
      lib.mkOptionDefault {
        # "Super_L --release" = "exec ${pkgs.dmenu}/bin/dmenu_run";
        "${mod}+space" = "exec sh ${openRofi}";
        "Mod1+Tab" = "workspace back_and_forth";

        # window control
        "${mod}+q" = "kill";

        # notification control
        "${mod}+n" = "exec --no-startup-id dunstctl context";
        "${mod}+Shift+n" = "exec --no-startup-id dunstctl history-pop";

        # focus
        "${mod}+j" = "focus down";
        "${mod}+k" = "focus up";
        "${mod}+h" = "focus left";
        "${mod}+l" = "focus right";

        # move
        "${mod}+Shift+j" = "move down";
        "${mod}+Shift+k" = "move up";
        "${mod}+Shift+h" = "move left";
        "${mod}+Shift+l" = "move right";

        # move workspace
        "${mod}+Shift+bracketleft" = "move workspace to output left";
        "${mod}+Shift+bracketright" = "move workspace to output right";

        # apps
        "${mod}+t" = "exec --no-startup-id wezterm";
        "${mod}+o" = "exec --no-startup-id obsidian";
        "${mod}+period" = "exec --no-startup-id sh ${openRofiEmoji}";
        # hmm https://github.com/flameshot-org/flameshot/issues/784
        "Print" = "exec --no-startup-id flameshot gui";

        # turn off workspace 10
        "${mod}+0" = "nop";
        "${mod}+Shift+0" = "nop";

        #next and previous
        "${mod}+bracketleft" = i3SwitchCmd (-1);
        "${mod}+bracketright" = i3SwitchCmd 1;
        "${mod}+Tab" = "workspace back_and_forth";

        "Control+Mod1+Delete" = "exec wezterm start --class term_btop --always-new-process btop -p 1";

        "${mod}+Delete" = "exec ${powermenu}/bin/powermenu";
      }
      // (builtins.listToAttrs (builtins.concatMap (v: [
        {
          name = "${mod}+${toString v}";
          value = "workspace ${toString v}";
        }
        {
          name = "${mod}+Shift+${toString v}";
          value = "exec --no-startup-id i3-msg \"move container to workspace ${toString v}; workspace ${toString v}\"";
        }
      ]) [1 2 3 4 5 6 7 8 9]));
    # this was for the mixer between chat and media but i kind of dont use that any more
    # keycodebindings = {
    #   "201" = "exec --no-startup-id j-ctl mixer inc -- -10";
    #   "202" = "exec --no-startup-id j-ctl mixer inc -- 10";
    # };
    bars = [
      {
        position = "top";
        statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-top.toml";
        fonts = {
          names = ["FiraCode Nerd Font Propo"];
          size = 11.0;
        };
        trayOutput = "primary";
        trayPadding = 0;
        colors = let
          workspace = bg: text: {
            background = bg.hex;
            border = bg.hex;
            text = text.hex;
          };
        in {
          background = theme.base0.hex;
          focusedBackground = theme.base2.hex;
          urgentWorkspace = workspace theme.red theme.base0;
          focusedWorkspace = workspace theme.blue theme.base0;
          activeWorkspace = workspace theme.base2 theme.base8;
          inactiveWorkspace = workspace theme.base0 theme.base8;
        };
      }
    ];
  };

  programs.i3status-rust = {
    enable = true;
    bars = {
      top = {
        icons = "material-nf";
        theme = "modern";
        settings.theme.theme = "modern";
        settings.theme.overrides = let
          text_w = theme.base8.hex;
          text_b = theme.base0.hex;
        in {
          idle_bg = theme.base0.hex;
          idle_fg = text_w;
          alternating_tint_bg = theme.base1.hex;
          # alternating_tint_fg = text_w;
          good_bg = theme.green.hex;
          good_fg = text_b;
          warning_bg = theme.orange.hex;
          warning_fg = text_b;
          critical_bg = theme.red.hex;
          critical_fg = text_b;
          info_bg = theme.blue.hex;
          info_fg = text_b;
        };
        blocks = [
          {
            block = "music";
            format = " $icon {$combo.str(max_w:30,rot_interval:2.0,rot_separator:' / ') $prev $play $next |}";
          }
          {
            block = "temperature";
            interval = 15;
            scale = "celsius";
            format = " $icon $average.eng()C ";
            # no idea how these numbers work.
            good = 1.0;
            idle = 999.0;
            info = 999.0;
            warning = 999.0;
          }
          {
            block = "cpu";
            interval = 15;
            format = " $icon $utilization ";
            # info_cpu = 20;
            warning_cpu = 50;
            critical_cpu = 90;
          }
          {
            block = "memory";
            interval = 15;
            format = " $icon $mem_used.eng(u:B,p:Gi,hide_unit:true,hide_prefix:true)/$mem_total.eng(u:B,p:Gi,hide_unit:true) ";
            warning_mem = 70;
            critical_mem = 90;
          }
          {
            block = "disk_space";
            path = "/";
            info_type = "available";
            warning = 20.0;
            alert = 5.0;
            format = " $icon $percentage ";
            format_alt = " $icon $available.eng(u:B,p:Gi,hide_unit:true,hide_prefix:true)/$total.eng(u:B,p:Gi,hide_unit:true) ";
          }
          {
            block = "docker";
            interval = 5;
            format = " $icon $running ";
          }
          {
            block = "custom";
            interval = 60 * 10;
            command = ''
              j-ctl weather "42.38874" "-71.1056" | jq -RcMj "{text: ., icon: \"weather_default\", state: \"Info\"}"
            '';
            json = true;
          }
          (let
            fmt = " $icon $percentage ";
          in {
            block = "battery";
            format = fmt;
            full_format = fmt;
            charging_format = fmt;
            empty_format = fmt;
            missing_format = "";
          })
          {
            block = "time";
            interval = 60;
            format = " $icon $timestamp.datetime(f:'%a %Y-%m-%d %I:%M') ";
          }
        ];
      };
    };
  };
}
