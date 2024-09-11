{pkgs, ...}: {
  services.xserver.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
    config = builtins.readFile ../scripts/xmonad/xmonad.hs;
  };
}
