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
    };
    initLua = ''
      -- DuckDB plugin configuration
      require("duckdb"):setup({
        mode = "standard"
      })
    '';
    settings = {
      manager.ratio = [1 2 5];
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
