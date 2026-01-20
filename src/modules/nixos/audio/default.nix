{ self, lib, ... }:
{
  flake.modules.nixos.xalaynix = 
  { config, lib, ... }: 
  {
    options.xalaynix.audio.enable = lib.mkOption {
      type = lib.types.bool;
      description = ''
        Whether to enable audio support.
      '';
      default = true;
    };

    config = lib.mkIf (!config.xalaynix.enable) {
      xalaynix.audio.enable = lib.mkForce false;
    };
  };
}