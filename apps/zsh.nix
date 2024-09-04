{pkgs, ...}: {
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [
      "--cmd cd"
    ];
  };
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      l = "ls -lh";
      g = "lazygit";
      d = "lazydocker";
      y = "yazi";
      sys = "systemctl-tui";
      weather = "curl \"v2.wttr.in/Cambridge+MA?u\"";
      brightness = "light -S";
      setclip = "xclip -selection c";
      getclip = "xclip -selection c -o";
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
      autoload -z edit-command-line
      zle -N edit-command-line
      bindkey "^E" edit-command-line
      function yy() {
      	local tmp="$(mktemp -t "yazi-cwd.XXXXX")"
      	yazi "$@" --cwd-file="$tmp"
      	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
      		cd $cwd
      	fi
      	rm -f -- "$tmp"
      }
      # ctrl + left
      bindkey ";5D" backward-word
      # ctrl + right
      bindkey ";5C" forward-word
    '';
  };
}
