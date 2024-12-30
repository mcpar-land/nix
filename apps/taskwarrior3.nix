{pkgs, ...}: {
  home.packages = with pkgs; [
    taskwarrior3
  ];
  age.secrets.taskwarrior_config = {
    file = ../secrets/taskwarrior_config.age;
    path = ".taskwarrior_config_secret";
  };
  programs.zsh.shellAliases.tw = "taskwarrior-tui";

  systemd.user.timers."taskwarrior-sync" = {
    Unit.Description = "timer for taskwarrior syncing";
    Timer = {
      OnUnitInactiveSec = "1m";
      Unit = "taskwarrior-sync";
    };
    Install.WantedBy = ["timers.target"];
  };

  systemd.user.services."taskwarrior-sync" = {
    Unit.Description = "automatic syncing for taskwarrior";
    Install.WantedBy = ["default.target"];
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.taskwarrior3}/bin/task sync";
    };
  };

  home.file = {
    "./.taskrc".text = ''
      data.location=~/.task
      news.version=3.1.0

      include dark-16.theme

      urgency.project.coefficient=0

      include ~/.taskwarrior_config_secret
    '';
  };
}
