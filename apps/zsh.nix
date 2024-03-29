{pkgs, ...}: {
  home.packages = with pkgs; [
    fzf
  ];
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [
      "--cmd cd"
    ];
  };
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      l = "ls -l";
      g = "lazygit";
      n = "nnn -e";
    };
    history.size = 10000;
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = ../configs/p10k-config;
        file = "p10k.zsh";
      }
    ];
  };
}
