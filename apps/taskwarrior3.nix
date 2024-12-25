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

      rc.hooks=1

      sync.server.url=https:\/\/taskchampion.breezystatic77.xyz
      include ~/.taskwarrior_config_secret
    '';
    "./.task/hooks/on-exit-sync".text = ''
      #!/bin/sh
      # This hooks script syncs task warrior to the configured task server.
      # The on-exit event is triggered once, after all processing is complete.
      # https://gist.github.com/primeapple/d3d82fbd28e9134d24819dd72430888e

      # Make sure hooks are enabled

      check_for_internet() {
        # check for internet connectivity
        nc -z 8.8.8.8 53  >/dev/null 2>&1
        if [ $? != 0 ]; then
          exit 0
        fi
      }

      # Count the number of tasks modified
      n=0
      while read modified_task
      do
        n=$(($n + 1))
      done

      if (($n > 0)); then
        check_for_internet
        date >> ~/.task/sync_hook.log
        task rc.verbose:nothing sync >> ~/.task/sync_hook.log &
      fi

      exit 0
    '';
  };
}
