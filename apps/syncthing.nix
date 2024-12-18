{
  key_secret,
  cert_secret,
}: {
  pkgs,
  config,
  ...
}: {
  age.secrets.syncthing_key.file = key_secret;
  age.secrets.syncthing_cert.file = cert_secret;
  age.secrets.syncthing_pass.file = ../secrets/st_password.age;
  services.syncthing = {
    enable = true;
    key = config.age.secrets.syncthing_key.path;
    cert = config.age.secrets.syncthing_cert.path;
    passwordFile = config.age.secrets.syncthing_pass.path;
  };
}
