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
      d = "lazydocker";
      y = "yazi";
      weather = "curl v2.wttr.in";
      reload-bar = "~/.config/ewwscripts/launch";
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
    initExtra = ''
      function yy() {
      	local tmp="$(mktemp -t "yazi-cwd.XXXXX")"
      	yazi "$@" --cwd-file="$tmp"
      	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
      		cd $cwd
      	fi
      	rm -f -- "$tmp"
      }
    '';
  };
}
