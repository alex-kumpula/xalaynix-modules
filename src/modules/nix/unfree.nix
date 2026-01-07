{ self, lib, ... }:
{
  flake.modules.nixos.xalaynix = 
  { config, lib, ... }: 
  {
    nixpkgs.config.allowUnfree = true;
  };
}