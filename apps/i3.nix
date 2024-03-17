{
  pkgs,
  lib,
  theme,
  ...
}: let
  mod = "Mod4";
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

  xsession.windowManager.i3.enable = true;
  xsession.windowManager.i3.config = {
    modifier = mod;
    terminal = "alacritty";
    gaps.inner = theme.gap;
    gaps.outer = 0;
    window.titlebar = false;
    window.border = 0;
    focus.followMouse = false;

    startup = [
      {
        command = "feh --bg-scale ${../wallpapers/martinaise2.png}";
      }
      {
        command = "steam -nofriendsui -silent";
      }
    ];

    keybindings = lib.mkOptionDefault {
      # "Super_L --release" = "exec ${pkgs.dmenu}/bin/dmenu_run";
      "${mod}+space" = "exec pkill rofi || rofi -show drun -show-icons";
      "Mod1+Tab" = "exec pkill rofi || rofi -show window -show-icons";

      # window control
      "${mod}+q" = "kill";

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
      "${mod}+t" = "exec alacritty";
      "${mod}+b" = "exec google-chrome-stable chrome://newtab --profile-directory=\"Default\"";
    };
    # bars = (import ./i3bars.nix) {
    #   pkgs = pkgs;
    #   gap = gap;
    # };
  };
}
