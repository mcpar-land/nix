let
  publicKey = builtins.readFile ../configs/ssh/id_rsa.pub;
  secrets = [
    "test_secret"
    "miniflux_host"
    "miniflux_password"
    "ssh_config"
    "aerc_accounts"
    "st_desktop_key"
    "st_desktop_cert"
    "st_laptop_key"
    "st_laptop_cert"
    "st_password"
    "taskwarrior_config"
  ];
in
  builtins.listToAttrs (map (
      s: {
        name = "${s}.age";
        value = {publicKeys = [publicKey];};
      }
    )
    secrets)
