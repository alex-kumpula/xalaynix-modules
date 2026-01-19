{ self, lib, ... }:
{
  flake.modules.nixos.xalaynix = 
  { config, lib, ... }: 
  {
    services.xserver.displayManager.gdm.enable = true;
  };
}