{
  host,
  systemd-label,
  description,
  dir,
}: {pkgs, ...}: {
  systemd.user.services.${systemd-label} = {
    Unit = {
      Description = description;
    };
    Install = {
      WantedBy = ["default.target"];
    };
    Service = {
      ExecStart = "${pkgs.sshfs}/bin/sshfs ${host}: ${dir} -f -v -o -auto_unmount";
      Restart = "always";
      ExecStop = "${pkgs.fuse}/bin/fusermount -uz ${dir}";
    };
  };
}
