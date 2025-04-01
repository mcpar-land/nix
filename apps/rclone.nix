{pkgs, ...}: {
  options.programs.rclone.enable = true;
  options.programs.rclone.remotes = {
    s3.config = {
      name = "s3";
      provider = "AWS";
      env_auth = true;
      region = "us-east-1";
    };
  };
}
