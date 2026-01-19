{ self, lib, ... }:
{
  flake.modules.nixos.xalaynix = 
  { config, lib, ... }: 
  {
    options.xalaynix.audio.backend = lib.mkOption {
      type = lib.types.enum [ "pipewire" "pulseaudio" "alsa" ];
      description = ''
        The audio backend to use. 
        "pipewire" enables PipeWire as the audio server.
        "pulseaudio" enables PulseAudio as the audio server.
        "alsa" uses ALSA directly without an audio server.
      '';
      default = "pipewire";
    };
  };
}