{
  "test_secret.age".publicKeys = [
    (builtins.readFile ../configs/ssh/id_rsa.pub)
  ];
}
