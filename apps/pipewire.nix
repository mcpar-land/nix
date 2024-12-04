{
  outputDeviceId,
  inputDeviceId,
}: {pkgs, ...}: let
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
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
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
        {
          cmd = "set-default-source";
          args = "rnnoise_source";
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
    extraConfig.pipewire."12-rnnoise-microphone" = {
      "context.modules" = [
        {
          name = "libpipewire-module-filter-chain";
          args = {
            "node.description" = "Noise Canceling source";
            "media.name" = "Noise Canceling source";
            "filter.graph" = {
              nodes = [
                {
                  type = "ladspa";
                  name = "rnnoise";
                  plugin = "${pkgs.rnnoise-plugin}/lib/ladspa/librnnoise_ladspa.so";
                  label = "noise_suppressor_stereo";
                  control = {
                    "VAD Threshold (%)" = 85.0;
                    "VAD Grace Period (ms)" = 200;
                    "Retroactive VAD Grace (ms)" = 50;
                  };
                }
              ];
            };
            "capture.props" = {
              "node.name" = "capture.rnnoise_source";
              "node.description" = "Noise Cancelled Microphone (In)";
              "node.passive" = true;
              "audio.rate" = 48000;
              "target.object" = inputDeviceId;
            };
            "playback.props" = {
              "node.description" = "Noise Cancelled Microphone (Out)";
              "node.name" = "rnnoise_source";
              "media.class" = "Audio/Source";
              "audio.rate" = 48000;
            };
          };
        }
      ];
    };
  };
}
