{pkgs, ...}: let
  # you have to EDIT THE HEADER FILE to change keybinds.
  patchedNnn = pkgs.nnn.overrideAttrs (final: prev: {
    patches =
      (prev.patches or [])
      ++ [
        ./keybinds.patch
      ];
  });
in {
  programs.nnn = {
    enable = true;
    extraPackages = with pkgs; [ffmpegthumbnailer mediainfo sxiv tabbed mpv zathura];
    package = patchedNnn.override {
      withNerdIcons = true;
    };
    plugins.src =
      (pkgs.fetchFromGitHub {
        owner = "jarun";
        repo = "nnn";
        rev = "v5.0";
        sha256 = "sha256-HShHSjqD0zeE1/St1Y2dUeHfac6HQnPFfjmFvSuEXUA=";
      })
      + "/plugins";
    plugins.mappings = {
      "p" = "preview-tabbed";
      "i" = "imgview";
    };
  };
}
