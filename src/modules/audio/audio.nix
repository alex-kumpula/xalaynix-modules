{ self, lib, ... }:
{
  flake.modules.generic.xalaynix = 
  { config, lib, ... }: 
  {
    options.xalaynix.audio.enable = lib.mkOption {
      type = lib.types.bool;
      description = ''
        Whether to enable audio support.
      '';
      default = true;
    };
  };
}