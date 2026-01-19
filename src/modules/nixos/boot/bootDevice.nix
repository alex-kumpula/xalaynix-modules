{ ... }:
{
  flake.modules.nixos.xalaynix = 
  { lib, ... }: 
  {
    options.xalaynix.boot.bootDevice = lib.mkOption {
      type = lib.types.str;
      description = '' 
        The path of the device that the bootloader should reside on.
        Example: "/dev/vda"
      '';
    };
  };
}