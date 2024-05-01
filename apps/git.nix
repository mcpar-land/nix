{
  config,
  lib,
  pkgs,
  theme,
  ...
}: let
  gpg = import ../gpg.nix;
in {
  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
    extensions = with pkgs; [
      gh-dash
    ];
  };
  programs.lazygit = {
    enable = true;
    settings = {
      git = {
        paging = {
          pager = "delta --tabs 2 --dark --paging=never";
        };
      };
    };
  };
  programs.git = {
    enable = true;
    userName = "mcpar-land";
    userEmail = "john@mcpar.land";
    signing = {
      key = gpg.gpgKeyFingerprint;
      signByDefault = true;
    };
    delta = {
      enable = true;
      options = {
        features = "decorations";
        side-by-side = true;
        line-numbers = false;
        hyperlinks = true;
      };
    };
  };
}
