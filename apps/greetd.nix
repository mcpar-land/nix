{pkgs, ...}: {
  # services.displayManager.cosmic-greeter.enable = true;
  services.greetd = {
    enable = true;
    settings = {
      terminal.vt = 1;
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --user-menu --cmd sway";
      };
    };
  };
  environment.etc."greetd/environments".text = ''
    sway
    zsh
  '';
  # https://github.com/sjcobb2022/nixos-config/blob/f904d7ad8a0ce0f67fef2a13fa39b7e43912ab1f/hosts/common/optional/greetd.nix
  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal";
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };
}
