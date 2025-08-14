{pkgs, ...}: {
  home.packages = with pkgs; [
    chafa
    ghostscript
    poppler
  ];

  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    plugins = {
      duckdb = pkgs.yaziPlugins.duckdb;
      piper = pkgs.yaziPlugins.piper;
    };
    initLua = ''
      -- DuckDB plugin configuration
      require("duckdb"):setup({
        mode = "standard"
      })
    '';
    settings = {
      mgr.ratio = [1 2 5];
      plugin = {
        prepend_previewers = [
          {
            name = "*.csv";
            run = "duckdb";
          }
          {
            name = "*.tsv";
            run = "duckdb";
          }
          {
            name = "*.json";
            run = "duckdb";
          }
          {
            name = "*.parquet";
            run = "duckdb";
          }
          {
            name = "*.txt";
            run = "duckdb";
          }
          {
            name = "*.xlsx";
            run = "duckdb";
          }
          {
            name = "*.db";
            run = "duckdb";
          }
          {
            name = "*.duckdb";
            run = "duckdb";
          }
          {
            name = "*.mp3";
            run = "piper -- ${pkgs.id3v2}/bin/id3v2 -l \"$1\"";
          }
          {
            name = "*.md";
            run = "piper -- CLICOLOR_FORCE=1 ${pkgs.glow}/bin/glow -w=$w -s=dark \"$1\"";
          }
          {
            name = "*.zip";
            run = "piper -- zipinfo \"$1\"";
          }
        ];

        append_previewers = [
          {
            name = "*";
            run = "piper -- ${pkgs.hexyl}/bin/hexyl --border=none --terminal-width=$w \"$1\"";
          }
        ];

        # prepend_preloaders = [
        #   {
        #     name = "*.csv";
        #     run = "duckdb";
        #     multi = false;
        #   }
        #   {
        #     name = "*.tsv";
        #     run = "duckdb";
        #     multi = false;
        #   }
        #   {
        #     name = "*.json";
        #     run = "duckdb";
        #     multi = false;
        #   }
        #   {
        #     name = "*.parquet";
        #     run = "duckdb";
        #     multi = false;
        #   }
        #   {
        #     name = "*.txt";
        #     run = "duckdb";
        #     multi = false;
        #   }
        #   {
        #     name = "*.xlsx";
        #     run = "duckdb";
        #     multi = false;
        #   }
        # ];
      };
    };
  };
}
