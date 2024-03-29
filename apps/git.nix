{
  config,
  lib,
  pkgs,
  theme,
  ...
}: {
  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
  };
  programs.lazygit.enable = true;
  programs.git = {
    enable = true;
    userName = "mcpar-land";
    userEmail = "john@mcpar.land";
    delta = {
      enable = true;
      options = {
        features = "decorations";
        side-by-side = true;
        line-numbers = true;
      };
    };
  };
}
