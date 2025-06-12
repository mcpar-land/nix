{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    unstable.xwayland-satellite
  ];
  programs.xwayland.enable = true;
  # services.displayManager.cosmic-greeter.enable = true;
  services.greetd = {
    enable = true;
    settings = {
      terminal.vt = 1;
      default_session = {
        command = "${pkgs.cage}/bin/cage -d -m extend -s -- ${pkgs.greetd.gtkgreet}/bin/gtkgreet";
      };
    };
  };
  environment.etc."greetd/environments".text = ''
    niri
    zsh
  '';
  systemd.user.services.xwayland-satellite = {
    description = "Xwayland outside your wayland";
    bindsTo = ["graphical-session.target"];
    partOf = ["graphical-session.target"];
    after = ["graphical-session.target"];
    requisite = ["graphical-session.target"];
    wantedBy = ["graphical-session.target"];
    serviceConfig = {
      Type = "notify";
      NotifyAccess = "all";
      ExecStart = "${pkgs.xwayland-satellite}/bin/xwayland-satellite";
      StandardOutput = "journal";
    };
  };
}
