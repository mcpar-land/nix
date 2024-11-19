let
  config = [
    {
      Host = "civera-bastion";
      HostName = "44.206.0.227";
      User = "ubuntu";
      IdentityFile = "~/.ssh/civera-aws-prod.pem";
    }
    {
      Host = "civera-web-staging";
      HostName = "104.237.151.215";
      User = "jmcparland";
    }
    {
      Host = "civera-db1-staging";
      HostName = "162.216.17.5";
      User = "jmcparland";
    }
    {
      Host = "civera-db2-staging";
      HostName = "45.33.80.32";
      User = "jmcparland";
    }
    {
      Host = "civera-web-production";
      HostName = "104.200.31.92";
      User = "jmcparland";
    }
    {
      Host = "civera-db1-production";
      HostName = "173.255.228.92";
      User = "jmcparland";
    }
    {
      Host = "civera-db2-production";
      HostName = "45.56.96.245";
      User = "jmcparland";
    }
    {
      Host = "10.120.10.* 10.120.11.* 10.120.12.*";
      ProxyCommand = "ssh -W %h:%p civera-bastion";
      IdentityFile = "~/.ssh/civera-aws-prod.pem";
      User = "ubuntu";
    }
    {
      Host = "desktop-lan";
      HostName = "10.0.0.107";
      Port = "5346";
      IdentityFile = "~/.ssh/id_rsa";
    }
    {
      Host = "laptop-lan";
      HostName = "j-laptop";
      Port = "5346";
      IdentityFile = "~/.ssh/id_rsa";
    }
    {
      Host = "jamrock";
      HostName = "10.0.0.127";
      Port = "22";
      User = "nixos";
      IdentityFile = "~/.ssh/id_rsa";
    }
    {
      Host = "homelab-nat";
      HostName = "5.161.249.54";
      Port = "22";
      User = "nixos";
      IdentityFile = "~/.ssh/id_rsa";
    }
    {
      Host = "civera-ftp";
      HostName = "ftp.aws.elstats.com";
      User = "civera_johnmcparland";
      IdentityFile = "~/.ssh/id_rsa";
    }
    {
      Host = "sbox";
      HostName = "u428278.your-storagebox.de";
      User = "u428278";
      IdentityFile = "~/.ssh/id_rsa";
    }
  ];
  makeEntry = inputs: let
    host = inputs.Host;
    keys = builtins.filter (k: k != "Host") (builtins.attrNames inputs);
    kvs =
      map (k: {
        k = k;
        v = inputs."${k}";
      })
      keys;
  in
    builtins.concatStringsSep "\n" (
      ["Host ${host}"]
      ++ (map (e: "  ${e.k} ${e.v}") kvs)
    );
in
  builtins.concatStringsSep "\n" (map makeEntry config)