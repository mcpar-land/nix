{
  pkgs,
  lib,
  theme,
  monitor-list,
  config,
  ...
}: let
  mod = "Mod4";
  sessionStart = pkgs.writeShellScript "sway-session" ''
    # needed to activate the keyring
    # https://wiki.archlinux.org/title/GNOME/Keyring#PAM_method
    dbus-update-activation-environment --all
    # why does services.libinput.mouse.middleEmulation = false not work??
    # xinput set-prop "SteelSeries SteelSeries Rival 600" "libinput Middle Emulation Enabled" 0
  '';
  openRofi = pkgs.writeShellScript "open-rofi" ''
    pkill rofi
    rofi \
      -show combi \
      -combi-modes "window,drun,ssh" \
      -show-icons \
      -modes combi \
      -display-drun "" \
      -display-combi "" \
      -display-window "" \
      -window-thumbnail \
      -ssh-command "wezterm ssh {host}"
  '';
  openRofiEmoji = pkgs.writeShellScript "open-rofi-emoji" ''
    rofi -modi emoji -show emoji -theme-str 'listview { columns: 6; } window { width: 1280px; }'
  '';
  swayWorkspaceSwitchCmd = offset: "exec \"j-ctl sway switch --displays ${builtins.concatStringsSep "," monitor-list} --offset ${toString offset}\"";
  powermenu = pkgs.custom-rofi-menu "powermenu" {
    options = [
      {
        label = "Logout";
        exec = "loginctl terminate-session ''";
      }
      {
        label = "Lock";
        exec = "xautolock -locknow";
      }
      {
        label = "Screen Off";
        exec = "xset -display :0.0 dpms force off";
      }
      {
        label = "Suspend";
        exec = "systemctl suspend";
      }
    ];
  };
in {
  imports = [
    ./screenshot.nix
    ./waybar.nix
    ./mako.nix
  ];
  home.packages = with pkgs; [
    brightnessctl
    playerctl
    libnotify
    swaylock
  ];
  wayland.windowManager.sway = {
    enable = true;
    systemd.enable = true;
    wrapperFeatures.gtk = true;
    extraConfig = ''
      exec --no-startup-id ${sessionStart}
      exec ${pkgs.swayidle}/bin/swayidle -w \
        timeout 600 'swaymsg "output * power off"' \
          resume 'swaymsg "output * power on"'

      for_window [class="zoom"] floating enable
      for_window [class="zoom" title="Zoom - Licensed Account"] floating disable
      for_window [class="zoom" title="Zoom - Free Account"] floating disable
      for_window [class="zoom" title="Zoom Meeting"] floating disable
      for_window [class="zoom" title="Zoom Webinar"] floating disable

      for_window [class="firefox"] border pixel 1

      # Brightness size
      set $brightness_size 5
      # Framework Laptop F7: XF86MonBrightnessDown
      # The --min-value option is important to prevent the complete darkness.
      bindsym XF86MonBrightnessDown exec "brightnessctl --device intel_backlight --min-value=1 set $brightness_size%-"
      # Framework Laptop F8: XF86MonBrightnessUp
      bindsym XF86MonBrightnessUp exec "brightnessctl --device intel_backlight set $brightness_size%+"

      set $volume_size 5
      bindsym XF86AudioMute exec "i3-volume -n mute"
      bindsym XF86AudioLowerVolume exec "wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%-"
      bindsym XF86AudioRaiseVolume exec "wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+"

      bindsym XF86AudioPrev exec "playerctl previous"
      bindsym XF86AudioPlay exec "playerctl play-pause"
      bindsym XF86AudioNext exec "playerctl next"

      input type:touchpad natural_scroll enabled
      input type:touchpad scroll_factor 0.75
      input type:touchpad click_method clickfinger
      input type:touchpad clickfinger_button_map lrm
    '';
    config = {
      modifier = mod;
      terminal = "wezterm";
      # gaps.inner = theme.gap;
      # gaps.outer = theme.gap;
      window.titlebar = true;
      window.border = 1;
      focus.followMouse = false;
      focus.mouseWarping = true;

      fonts = {
        names = ["GohuFont"];
        style = "Regular";
        size = 10.206;
      };
      colors = let
        colorSet = baseColor: textColor: {
          background = baseColor;
          border = baseColor;
          childBorder = baseColor;
          indicator = baseColor;
          text = textColor;
        };
      in {
        focused = colorSet theme.blue.hex theme.black.hex;
        focusedInactive = colorSet theme.base1.hex theme.white.hex;
        unfocused = colorSet theme.base0.hex theme.white.hex;
        urgent = colorSet theme.red.hex theme.white.hex;
      };

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
          "${mod}+n" = "exec swaync-client -t -sw";
          # "${mod}+n" = "exec --no-startup-id dunstctl context";
          # "${mod}+Shift+n" = "exec --no-startup-id dunstctl history-pop";

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
          "${mod}+b" = "exec --no-startup-id rofi-firefox";
          "${mod}+period" = "exec --no-startup-id sh ${openRofiEmoji}";
          # hmm https://github.com/flameshot-org/flameshot/issues/784
          "Print" = "exec screenshot";

          # turn off workspace 10
          "${mod}+0" = "nop";
          "${mod}+Shift+0" = "nop";

          #next and previous
          "${mod}+bracketleft" = swayWorkspaceSwitchCmd (-1);
          "${mod}+bracketright" = swayWorkspaceSwitchCmd 1;
          # "${mod}+bracketleft" = "workspace prev";
          # "${mod}+bracketright" = "workspace next";
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
            value = "exec --no-startup-id swaymsg \"move container to workspace ${toString v}; workspace ${toString v}\"";
          }
        ]) [1 2 3 4 5 6 7 8 9]));
      # this was for the mixer between chat and media but i kind of dont use that any more
      # keycodebindings = {
      #   "201" = "exec --no-startup-id j-ctl mixer inc -- -10";
      #   "202" = "exec --no-startup-id j-ctl mixer inc -- 10";
      # };
      bars = [];
    };
  };
}
