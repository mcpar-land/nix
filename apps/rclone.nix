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
    '';
  };
}
