{
  pkgs,
  config,
  ...
}: {
  programs.newsboat = {
    enable = true;
    extraConfig = ''
      urls-source "miniflux"
      miniflux-url `cat ${config.age.secrets.miniflux_host.path}`
      miniflux-login "admin"
      miniflux-password `cat ${config.age.secrets.miniflux_password.path}`
    '';
  };
  age.secrets.miniflux_host = {
    file = ../secrets/miniflux_host.age;
    mode = "770";
  };
  age.secrets.miniflux_password = {
    file = ../secrets/miniflux_password.age;
    mode = "770";
  };
}
