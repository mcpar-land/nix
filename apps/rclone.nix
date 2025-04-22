{pkgs, ...}: {
  home.packages = with pkgs; [
    rclone
  ];

  home.file.".config/rclone/rclone.conf" = {
    recursive = true;
    text = ''
      [s3]
      type = s3
      provider = AWS
      env_auth = true
      region = us-east-1

      [civera-sftp]
      type = sftp
      host = ftp.aws.elstats.com
      user = civera_johnmcparland
      known_hosts_file = ~/.ssh/known_hosts
      key_file = ~/.ssh/id_rsa

      [desktop-lan]
      type = sftp
      host = 10.0.0.107
      port = 5346
      known_hosts_file = ~/.ssh/known_hosts
      key_file = ~/.ssh/id_rsa
    '';
  };
}
