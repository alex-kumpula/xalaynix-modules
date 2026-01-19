{ self, lib, ... }:
{
  flake.modules.nixos.xalaynix = 
  { config, lib, ... }: 
  {
    config = lib.mkIf (config.xalaynix.boot.loader == "grub-minimal") {
      boot.loader.grub.enable = true;

      boot.loader.grub.device                = lib.mkDefault config.xalaynix.boot.bootDevice;
      boot.loader.grub.useOSProber           = lib.mkDefault true;
      boot.loader.grub.efiSupport            = lib.mkDefault true;
      boot.loader.grub.efiInstallAsRemovable = lib.mkDefault true;
    };
  };
}