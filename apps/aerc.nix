{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    pkgs.pandoc
    pkgs.lynx
  ];

  age.secrets.aerc_accounts = {
    file = ../secrets/aerc_accounts.age;
  };
  programs.aerc = {
    enable = true;
    package = pkgs.writeShellScriptBin "aerc" ''
      ${pkgs.aerc}/bin/aerc --accounts-conf ${config.age.secrets.aerc_accounts.path} $@
    '';
    extraConfig = {
      general = {
        default-menu-cmd = "fzf --multi";
      };
      filters = {
        "text/plain" = "colorize";
        "text/calendar" = "calendar";
        "message/delivery-status" = "colorize";
        "message/rfc822" = "colorize";
        "text/html" = "lynx -stdin -dump | colorize";
      };
    };
  };
}
