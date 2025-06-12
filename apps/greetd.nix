{pkgs, ...}: {
  # services.displayManager.cosmic-greeter.enable = true;
  services.greetd = {
    enable = true;
    settings = {
      terminal.vt = 1;
      default_session = {
        command = "${pkgs.cage}/bin/cage -d -m extend -s -- ${pkgs.greetd.gtkgreet}/bin/gtkgreet --background ${../wallpapers/martinaise2.png}";
      };
    };
  };
  environment.etc."greetd/environments".text = ''
    niri-session
    zsh
  '';
}
