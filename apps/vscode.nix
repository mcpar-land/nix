{pkgs, ...}: {
  # Pretty much exclusively use vscode for running Jupyter notebooks,
  # so this is a really slim and inflexible setup.
  programs.vscode = {
    enable = true;
    profiles.default = {
      userSettings = {
        workbench = {
          colorTheme = "Monokai Dimmed";
        };
        editor = {
          fontFamily = "'FiraCode Nerd Font Mono', monospace";
          smoothScrolling = true;
          cursorSmoothCaretAnimation = "on";
          notebook.cellToolbarVisibility = "hover";
          monokaiPro.fileIconsMonochrome = true;
          terminal.integrated.defaultProfile.linux = "zsh";
          terminal.explorerKind = "external";
        };
      };
      extensions = with pkgs.vscode-extensions; [
        ms-python.python
        ms-python.black-formatter
        ms-python.vscode-pylance
        ms-python.isort
        ms-toolsai.jupyter
        eamodio.gitlens
        mkhl.direnv
      ];
      enableExtensionUpdateCheck = false;
      enableUpdateCheck = false;
    };
    package = pkgs.vscodium;
    mutableExtensionsDir = false;
  };
}
