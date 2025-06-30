{
  pkgs,
  config,
  ...
}: let
  jiraWithSecret = pkgs.writeShellScriptBin "jira" ''
    export JIRA_API_TOKEN=$(cat ${config.age.secrets.jira-token.path})
    ${pkgs.jira-cli-go}/bin/jira "$@"
  '';
in {
  home.packages = [
    jiraWithSecret
  ];
  age.secrets.jira-token = {
    file = ../secrets/jira_token.age;
  };
  programs.zsh.initContent = ''
    eval "$(${jiraWithSecret}/bin/jira completion zsh)"
  '';
}
