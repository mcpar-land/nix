{pkgs, ...}:
pkgs.writeShellScriptBin "zipinfo-csv" ''
  echo "permissions,zip_version,size,file_info,compression_method,date,time,filename"
  zipinfo "$1" | tail -n+3 | head -n-1 | \
    sed -r 's/^(\S+) +(\S+ +\S+) +(\S+) +(\S+) +(\S+) +(\S+) +(\S+) +(.+)$/"\1","\2","\3","\4","\5","\6","\7","\8"/'
''
