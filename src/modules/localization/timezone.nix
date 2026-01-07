{ self, lib, ... }:
{
  flake.modules.nixos.xalaynix = 
  { config, lib, ... }: 
  {
    time.timeZone = lib.mkDefault "America/Edmonton";
  };
}