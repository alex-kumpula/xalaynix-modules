{ self, lib, ... }:
{
  flake.modules.nixos.xalaynix = 
  { config, lib, ... }:
  let
    cfg = config.xalaynix.audio;
  in
  {
    config = lib.mkIf (cfg.enable && cfg.backend == "pipewire") {
      services.pulseaudio.enable = lib.mkDefault false;
      security.rtkit.enable      = lib.mkDefault true;
      
      services.pipewire = {
        enable            = lib.mkDefault true;
        alsa.enable       = lib.mkDefault true;
        alsa.support32Bit = lib.mkDefault true;
        pulse.enable      = lib.mkDefault true;
      };
    };
  };
}