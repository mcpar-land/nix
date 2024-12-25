{pkgs, ...}: {
  home.packages = with pkgs; [
    taskwarrior3
  ];
  age.secrets.taskwarrior_config = {
    file = ../secrets/taskwarrior_config.age;
    path = ".taskwarrior_config_secret";
  };
  programs.zsh.shellAliases.tw = "taskwarrior-tui";

  home.file = {
    "./.taskrc".text = ''
      data.location=~/.task
      news.version=3.1.0

      include dark-16.theme

      sync.server.url=https:\/\/taskchampion.breezystatic77.xyz
      include ~/.taskwarrior_config_secret
    '';
    "./.task/hooks/on-exit.01-sync".text = ''
      task sync
    '';
  };
}
