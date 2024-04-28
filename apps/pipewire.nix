{outputDeviceId}: let
  loopback = name: description: {
    name = "libpipewire-module-loopback";
    args = {
      "audio.position" = ["FL" "FR"];
      "capture.props" = {
        "media.class" = "Audio/Sink";
        "node.name" = "loopback-${name}";
        "node.description" = "📢 ${description} (In)";
      };
      "playback.props" = {
        "node.name" = "loopback-${name}.output";
        "node.description" = "📢 ${description} (Out)";
        "node.passive" = false;
        "target.object" = outputDeviceId;
      };
    };
  };
in {
  enable = true;
  alsa.enable = true;
  alsa.support32Bit = true;
  pulse.enable = true;
  extraConfig.pipewire-pulse."10-force-default" = {
    "pulse.cmd" = [
      {
        cmd = "set-default-sink";
        args = "loopback-media";
      }
    ];
  };
  extraConfig.pipewire."11-custom-loopbacks" = {
    "context.modules" = [
      (loopback "media" "Media")
      # (loopback "game" "Game")
      (loopback "chat" "Chat")
    ];
  };
}
