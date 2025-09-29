{pkgs, ...}: let
  variety = pkgs.variety.override {fehSupport = true;};
in {
  home.packages = [variety];
  systemd.user.services.variety = {
    Unit = {
      Description = "Variety Wallpaper Manager";
      Requires = ["tray.target"];
      After = ["tray.target"];
      PartOf = ["graphical-session.target"];
      StartLimitIntervalSec = 30;
      StartLimitBurst = 5;
    };
    Service = {
      ExecStart = "${variety}/bin/variety --next";
      Restart = "on-failure";
      RestartSec = "5s";
    };
    Install = {WantedBy = ["graphical-session.target"];};
  };
}
