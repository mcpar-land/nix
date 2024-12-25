{pkgs, ...}: {
  home.packages = with pkgs; [
    taskwarrior3
  ];
  age.secrets.taskwarrior_config = {
    file = ../secrets/taskwarrior_config.age;
    path = ".taskwarrior_config_secret";
  };
  programs.zsh.shellAliases.tw = "taskwarrior-tui";
}
