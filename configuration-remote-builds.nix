{...}: {
  nix.settings.substituters = [
    "ssh://nix-ssh@10.0.0.127?ssh-key=/home/sc/.ssh/id_rsa&trusted=1"
  ];
  nix.distributedBuilds = true;
  nix.buildMachines = [
    {
      hostName = "10.0.0.127";
      sshUser = "nixos";
      sshKey = "/home/sc/.ssh/id_rsa";
      system = "x86_64-linux";
      protocol = "ssh";
      maxJobs = 32;
    }
  ];
}
