{pkgs, ...}: {
  home.packages = with pkgs; [
    chafa
    ghostscript
    poppler
  ];

  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
  };
}
