{pkgs, ...}: {
  programs.helix = {
    enable = true;
    settings = {
      theme = "monokai_pro_custom";
      editor = {
        line-number = "relative";
        cursorline = true;
        bufferline = "always";
        cursor-shape.insert = "bar";
        cursor-shape.normal = "block";
        cursor-shape.select = "underline";
        indent-guides.render = true;
        indent-guides.character = "┊";
        indent-guides.skip-levels = 1;
        file-picker.hidden = false;
        lsp.display-messages = true;
      };
      keys.normal = {
        # do vscode's ctrl + d behavior
        "C-d" = [
          "keep_primary_selection"
          "move_prev_word_start"
          "move_next_word_end"
          "search_selection"
          "select_mode"
        ];
        # move current line up one line
        "C-up" = [
          "extend_to_line_bounds"
          "delete_selection"
          "move_line_up"
          "paste_before"
        ];
        # move current line down one line
        "C-down" = [
          "extend_to_line_bounds"
          "delete_selection"
          "paste_after"
        ];
      };
      keys.select = {
        "C-d" = ["search_selection" "extend_search_next"];
      };
    };
    languages.language = [
      {
        name = "nix";
        auto-format = true;
        formatter.command = "alejandra";
        language-servers = ["nil"];
        indent.tab-width = 2;
        indent.unit = " ";
      }
      {
        name = "rust";
        auto-format = true;
        indent = {
          tab-width = 2;
          unit = "\t";
        };
      }
      {
        name = "go";
        auto-format = true;
        indent = {
          tab-width = 2;
          unit = "\t";
        };
      }
    ];
  };
  home.file."./.config/helix/themes/monokai_pro_custom.toml".source = (pkgs.formats.toml {}).generate "monokai_pro_custom" {
    inherits = "monokai_pro";
    "ui.background" = {fg = "foreground";};
  };
}
