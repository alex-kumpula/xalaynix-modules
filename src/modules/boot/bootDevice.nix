{ inputs, ... }:
{
  flake.modules.nixos.xalaynix = 
  { options, config, lib, ... }: 
  {
    options.xalaynix.bootDevice = lib.mkOption {
      type = lib.types.string;
      description = '' 
        The path of the device that the bootloader should reside on.
        Example: "/dev/vda"
      '';
    };

  };
}