{pkgs, ...}: {
  services.syncthing = {
    enable = true;
  };
  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager System Tray";
      Requires = ["graphical-session-pre.target"];
    };
  };
  systemd.user.services.syncthingtray = {
    Unit = {
      Description = "Syncthing Tray";
      Requires = ["tray.target"];
      After = ["network.target" "tray.target"];
      PartOf = ["graphical-session.target"];
      # https://www.redhat.com/en/blog/systemd-automate-recovery
      StartLimitIntervalSec = 30;
      StartLimitBurst = 5;
    };
    Service = {
      ExecStart = "${pkgs.syncthingtray-minimal}/bin/syncthingtray --wait";
      Restart = "on-failure";
      RestartSec = "5s";
    };
    Install = {WantedBy = ["graphical-session.target"];};
  };
}
