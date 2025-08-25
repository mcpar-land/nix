{pkgs, ...}: {
  home.packages = [pkgs.shpool];
  home.file.".config/shpool/config.toml" = {
    recursive = true;
    source = (pkgs.formats.toml {}).generate "config.toml" {
      prompt_prefix = "";
    };
  };
}
