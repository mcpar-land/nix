{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    swaylock
    xwayland-satellite
  ];
  services.displayManager = {
    defaultSession = "none+niri";
    autoLogin.enable = false;
    ly = {
      enable = true;
      settings = {
        animation = "colormix";
      };
    };
  };
  programs.niri.enable = true;
  programs.xwayland.enable = true;
  environment.variables.NIRI_CONFIG = "${../configs/niri/niri.kdl}";
}
