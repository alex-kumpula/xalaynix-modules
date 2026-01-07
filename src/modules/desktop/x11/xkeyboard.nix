{ self, lib, ... }:
{
  flake.modules.nixos.xalaynix = 
  { config, lib, ... }: 
  {
    services.xserver.xkb = lib.mkDefault {
      layout = "us";
      variant = "";
    };
  };
}