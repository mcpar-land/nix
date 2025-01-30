{pkgs, ...}: {
  home.packages = [
    (pkgs.writeShellScriptBin "csv-preview" ''
      pandoc -f csv -t markdown-simple_tables-multiline_tables /dev/stdin | less -S
    '')
    (pkgs.writeShellScriptBin "ls-csv" ''
      echo file_name,file_size,file_type
      find $@ -printf "\"%p\",%s,%y\n"
    '')
  ];
}
