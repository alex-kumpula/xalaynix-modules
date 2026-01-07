{ inputs, ... }:
{
  flake.modules.nixos.xalaynix =
  { config, lib, ... }: 
  let 
    cfg = config.xalaynix;
  in 
  {
    boot.loader.grub.enable = true;
    boot.loader.grub.device = cfg.boot-device;
    boot.loader.grub.useOSProber = true;

    boot.loader.grub.efiSupport = true;
    boot.loader.grub.efiInstallAsRemovable = true;
  };
}