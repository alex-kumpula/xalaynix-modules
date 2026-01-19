{ self, lib, ... }:
{
  flake.modules.nixos.xalaynix = 
  { config, lib, ... }: 
  {
    config = lib.mkIf (config.xalaynix.audio.backend == "pulseaudio") {
      # Enable sound with pulseaudio.
      services.pulseaudio.enable = true;
      # Disable pipewire if it was enabled elsewhere.
      services.pipewire.enable = false;
    };
  };
}