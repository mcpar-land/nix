{pkgs, ...}: {
  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;
    extraConfig = ''
      return {
        color_scheme = "Mikado (terminal.sexy)",
        hide_tab_bar_if_only_one_tab = true
      }
    '';
  };
}
