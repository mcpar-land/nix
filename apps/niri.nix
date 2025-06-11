{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    swaylock
    xwayland-satellite
  ];
  services.xserver.enable = false;
  services.displayManager.enable = true;
  services.displayManager.cosmic-greeter.enable = true;
  # services.displayManager.ly = {
  #   enable = true;
  #   settings = {
  #     animation = "colormix";
  #   };
  # };
  programs.niri.enable = true;
  programs.xwayland.enable = true;
  environment.variables.NIRI_CONFIG = "${../configs/niri/niri.kdl}";
}
