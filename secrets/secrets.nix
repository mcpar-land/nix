let
  publicKey = builtins.readFile ../configs/ssh/id_rsa.pub;
in {
  "test_secret.age".publicKeys = [publicKey];
  "miniflux_host.age".publicKeys = [publicKey];
  "miniflux_password.age".publicKeys = [publicKey];
  "ssh_config.age".publicKeys = [publicKey];
  "aerc_accounts.age".publicKeys = [publicKey];
}
