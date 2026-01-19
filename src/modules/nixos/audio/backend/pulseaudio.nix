{ self, lib, ... }:
{
  flake.modules.nixos.xalaynix = 
  { config, lib, ... }: 
  let
    cfg = config.xalaynix.audio;
  in
  {
    config = lib.mkIf (cfg.enable && cfg.backend == "pulseaudio") {
      # Enable sound with pulseaudio.
      services.pulseaudio.enable = lib.mkDefault true;

      # Disable pipewire if it was enabled elsewhere.
      services.pipewire.enable = lib.mkDefault false;
    };
  };
}