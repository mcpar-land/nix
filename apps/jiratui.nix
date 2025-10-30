{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    unstable.jiratui
  ];
  age.secrets.jiratui_config = {
    file = ../secrets/jiratui_config.age;
  };
  home.sessionVariables = {
    JIRA_TUI_CONFIG_FILE = config.age.secrets.jiratui_config.path;
  };
}
