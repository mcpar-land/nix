{
  pkgs,
  lib,
  theme,
  config,
  ...
}: let
  mod = "Mod4";
  sessionStart = pkgs.writeShellScript "i3-session" ''
    systemctl --user set-environment I3SOCK=$(${config.xsession.windowManager.i3.package}/bin/i3 --get-socketpath)
    systemctl --user start graphical-session-i3.target
    # needed to activate the keyring
    # https://wiki.archlinux.org/title/GNOME/Keyring#PAM_method
    dbus-update-activation-environment --all

    # launch eww
    ~/.config/ewwscripts/launch
  '';
  openRofi = pkgs.writeShellScript "open-rofi" ''
    pkill rofi
    rofi -show combi -combi-modes "drun,ssh" -show-icons -modes combi -display-drun "" -display-combi ""
  '';
  openRofiEmoji = pkgs.writeShellScript "open-rofi-emoji" ''
    rofi -modi emoji -show emoji -kb-custom-1 Ctrl+c -theme-str 'listview { columns: 6; } window { width: 1280px; }'
  '';
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
  '';
  xsession.windowManager.i3.config = {
    modifier = mod;
    terminal = "alacritty";
    gaps.inner = theme.gap;
    gaps.outer = 0;
    window.titlebar = false;
    window.border = 0;
    focus.followMouse = false;
    focus.mouseWarping = true;

    floating.criteria = [
      {class = "Pavucontrol";}
    ];

    keybindings =
      lib.mkOptionDefault {
        # "Super_L --release" = "exec ${pkgs.dmenu}/bin/dmenu_run";
        "${mod}+space" = "exec sh ${openRofi}";
        "Mod1+Tab" = "exec pkill rofi || rofi -show window -show-icons -window-thumbnail";

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
        "${mod}+Shift+comma" = "move workspace to output left";
        "${mod}+Shift+period" = "move workspace to output right";

        # apps
        "${mod}+t" = "exec --no-startup-id alacritty";
        # "${mod}+b" = "exec --no-startup-id google-chrome-stable chrome://newtab --profile-directory=\"Default\"";
        "${mod}+o" = "exec --no-startup-id obsidian";
        "${mod}+period" = "exec --no-startup-id sh ${openRofiEmoji}";
        # hmm https://github.com/flameshot-org/flameshot/issues/784
        "Print" = "exec --no-startup-id flameshot gui";

        # turn off workspace 10
        "${mod}+0" = "nop";
        "${mod}+Shift+0" = "nop";

        #next and previous
        "${mod}+bracketleft" = "workspace prev";
        "${mod}+bracketright" = "workspace next";
        "${mod}+Tab" = "workspace back_and_forth";

        "Control+Mod1+Delete" = "exec alacritty -e btop -p 1";
      }
      // (builtins.listToAttrs (map (v: {
        name = "${mod}+${toString v}";
        value = "workspace ${toString v}";
      }) [1 2 3 4 5 6 7 8 9]));
    bars = [];
  };
}
