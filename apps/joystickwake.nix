{pkgs, ...}: {
  systemd.user.services."joystickwake" = {
    Unit.Description = "joystick input prevents screen from sleeping";
    Unit.After = ["niri.service"];
    Install.WantedBy = ["graphical-session.target"];
    Service = {
      ExecStart = "${pkgs.joystickwake}/bin/joystickwake --cooldown 60 --loglevel info";
      Restart = "on-failure";
      RestartSec = "5s";
    };
  };
}
