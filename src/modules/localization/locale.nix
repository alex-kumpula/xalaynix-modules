{ self, lib, ... }:
{
  flake.modules.nixos.xalaynix = 
  { config, lib, ... }: 
  {
    i18n.defaultLocale = lib.mkDefault "en_CA.UTF-8";
  };
}