{ ... }:
{
  flake.modules.nixos.xalaynix = 
  { config, lib, ... }: 
  {
    options.xalaynix.boot.loader = lib.mkOption {
      type = lib.types.enum [ "grub-minimal" ];
      description = ''
        The bootloader to use. 
        "grub-minimal" enables GRUB as the boot loader.
      '';
      default = "grub";
    };
  };
}