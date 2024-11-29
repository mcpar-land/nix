{
  pkgs,
  config,
  ...
}: {
  age.secrets.aerc_accounts = {
    file = ../secrets/aerc_accounts.age;
  };
  programs.aerc = {
    enable = true;
    package = pkgs.writeShellScriptBin "aerc" ''
      ${pkgs.aerc}/bin/aerc --accounts-conf ${config.age.secrets.aerc_accounts.path} $@
    '';
  };
}
