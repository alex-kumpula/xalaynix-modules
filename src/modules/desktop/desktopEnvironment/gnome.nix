{ self, lib, ... }:
{
  flake.modules.nixos.xalaynix = 
  { config, lib, ... }: 
  {
    services.xserver.desktopManager.gnome.enable = true;
  };
}