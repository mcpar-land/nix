{
  pkgs,
  theme,
  ...
}: {
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
  programs.oh-my-posh = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      blocks = [
        {
          alignment = "left";
          type = "prompt";
          newline = true;
          segments = [
            {
              type = "text";
              foreground = "gray";
              style = "plain";
              template = "┌ ";
            }
            {
              type = "session";
              foreground = "gray";
              style = "plain";
              template = "{{ if .SSHSession }}{{ .UserName }}@{{ .HostName }} {{ end }}";
            }
            {
              type = "text";
              foreground = "blue";
              style = "plain";
              template = "{{ if .Env.SHPOOL_SESSION_NAME }}[{{ .Env.SHPOOL_SESSION_NAME }}] {{ end }}";
            }
            {
              type = "path";
              foreground = "blue";
              style = "plain";
              properties = {style = "full";};
              template = "{{ .Path }} ";
            }
            {
              type = "git";
              foreground = "gray";
              properties = {
                branch_ahead_icon = "⇡ ";
                branch_behind_icon = "⇣ ";
                branch_icon = "";
                fetch_status = true;
                fetch_upstream_icon = true;
                github_icon = "";
              };
              style = "plain";
              template = "{{ .UpstreamIcon }}{{ .HEAD }}{{if .BranchStatus }} {{ .BranchStatus }}{{ end }}{{ if .Working.Changed }}<#FFAFD7>*</>{{ .Working.String }}{{ end }}{{ if and (.Working.Changed) (.Staging.Changed) }} |{{ end }}{{ if .Staging.Changed }}  {{ .Staging.String }}{{ end }}{{ if gt .StashCount 0 }}  {{ .StashCount }}{{ end }} ";
            }
          ];
        }
        {
          alignment = "left";
          type = "prompt";
          segments = [
            {
              type = "executiontime";
              foreground = "yellow";
              properties = {
                style = "round";
                threshold = 5000;
              };
              style = "plain";
              template = "{{ .FormattedMs }}";
            }
          ];
        }
        {
          alignment = "left";
          type = "prompt";
          newline = true;
          segments = [
            {
              type = "text";
              foreground = "gray";
              style = "plain";
              template = "└ ";
            }
            {
              foreground = "gray";
              foreground_templates = [
                "{{ if gt .Code 0 }}red{{ end }}"
              ];
              properties = {always_enabled = true;};
              style = "plain";
              template = "Δ ";
              type = "status";
            }
          ];
        }
      ];
      console_title_template = "{{if .Root}}(Root) {{end}}{{.PWD}}";
      version = 3;
    };
  };
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      cat = "bat";
      du = "dust";
      l = "ls -lh";
      g = "lazygit";
      d = "lazydocker";
      sys = "systemctl-tui";
      weather = "curl \"v2.wttr.in/Cambridge+MA?u\"";
      brightness = "light -S";
      clipboard-set = "xclip -selection c";
      clipboard-get = "xclip -selection c -o";
    };
    history.size = 10000;
    initContent = ''
      autoload -z edit-command-line
      zle -N edit-command-line
      bindkey "^E" edit-command-line
      # ctrl + left
      bindkey ";5D" backward-word
      # ctrl + right
      bindkey ";5C" forward-word
      n ()
      {
          # Block nesting of nnn in subshells
          [ "''${NNNLVL:-0}" -eq 0 ] || {
              echo "nnn is already running"
              return
          }

          # The behaviour is set to cd on quit (nnn checks if NNN_TMPFILE is set)
          # If NNN_TMPFILE is set to a custom path, it must be exported for nnn to
          # see. To cd on quit only on ^G, remove the "export" and make sure not to
          # use a custom path, i.e. set NNN_TMPFILE *exactly* as follows:
          #      NNN_TMPFILE="''${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
          export NNN_TMPFILE="''${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

          # Unmask ^Q (, ^V etc.) (if required, see `stty -a`) to Quit nnn
          # stty start undef
          # stty stop undef
          # stty lwrap undef
          # stty lnext undef

          # The command builtin allows one to alias nnn to n, if desired, without
          # making an infinitely recursive alias
          command nnn "$@"

          [ ! -f "$NNN_TMPFILE" ] || {
              . "$NNN_TMPFILE"
              rm -f -- "$NNN_TMPFILE" > /dev/null
          }
      }
    '';
  };
}
