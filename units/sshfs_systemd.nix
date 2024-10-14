# this should go under systemd.user.services.(label here) in home manager
{
  host,
  description,
  dir,
  pkgs,
}: {
  Unit = {
    Description = description;
  };
  Install = {
    WantedBy = ["default.target"];
  };
  Service = {
    ExecStart = "${pkgs.sshfs}/bin/sshfs ${host}: ${dir} -f -v -o auto_unmount";
    Restart = "always";
    ExecStop = "${pkgs.fuse}/bin/fusermount -uz ${dir}";
  };
}
