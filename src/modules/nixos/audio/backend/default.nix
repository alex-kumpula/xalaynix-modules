{ self, lib, ... }:
{
  flake.modules.nixos.xalaynix = 
  { config, lib, ... }: 
  {
    options.xalaynix.audio.backend = lib.mkOption {
      type = lib.types.enum [ "none" "pipewire" "pulseaudio" ];
      description = ''
        The audio backend to use.
        "none" does nothing.
        "pipewire" enables PipeWire as the audio server.
        "pulseaudio" enables PulseAudio as the audio server.
      '';
      default = "none";
    };

    config = lib.mkIf (!config.xalaynix.audio.enable) {
      xalaynix.audio.backend = lib.mkForce "none";
    };
  };
}