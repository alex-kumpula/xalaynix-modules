{ self, lib, ... }:
{
  flake.modules.nixos.xalaynix = 
  { config, lib, ... }:
  let
    cfg = config.xalaynix.displayManager;
  in
  {
    config = lib.mkIf (cfg == "gdm-minimal") {
      services.displayManager.gdm.enable = true;
    };
  };
}