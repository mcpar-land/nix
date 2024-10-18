{pkgs, ...}: {
  home.packages = [
    (pkgs.writeShellScriptBin "csv-preview" ''
      pandoc -f csv -t markdown-simple_tables-multiline_tables /dev/stdin | less -S
    '')
  ];
}
