{pkgs, ...}: {
  systemd.user.services."joystickwake" = {
    Unit.Description = "joystick input prevents screen from sleeping";
    Install.WantedBy = ["graphical-session-i3.target"];
    Service = {
      ExecStart = "${pkgs.joystickwake}/bin/joystickwake --cooldown 60 --loglevel info";
      Restart = "on-failure";
      RestartSec = "5s";
    };
  };
}
