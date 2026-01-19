{ self, lib, ... }:
{
  flake.modules.nixos.xalaynix = 
  { config, lib, ... }: 
  {
    options.xalaynix.boot.enable = lib.mkOption {
      type = lib.types.bool;
      description = ''
        Whether to enable boot support.
      '';
      default = true;
    };
  };
}