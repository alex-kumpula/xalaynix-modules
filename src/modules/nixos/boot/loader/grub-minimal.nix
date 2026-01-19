{ self, lib, ... }:
{
  flake.modules.nixos.xalaynix = 
  { config, lib, ... }: 
  let 
    cfg = config.xalaynix.boot;
  in 
  {
    config = lib.mkIf (cfg.enable && cfg.loader == "grub-minimal") {
      boot.loader.grub.enable = true;

      boot.loader.grub.device                = lib.mkDefault config.xalaynix.boot.bootDevice;
      boot.loader.grub.useOSProber           = lib.mkDefault true;
      boot.loader.grub.efiSupport            = lib.mkDefault true;
      boot.loader.grub.efiInstallAsRemovable = lib.mkDefault true;
    };
  };
}