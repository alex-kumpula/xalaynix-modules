{ self, lib, ... }:
{
  flake.modules.nixos.xalaynix = 
  { config, lib, ... }: 
  {
    options.xalaynix.desktop.enable = lib.mkOption {
      type = lib.types.bool;
      description = ''
        Whether to enable desktop support.
      '';
      default = true;
    };

    config = lib.mkIf (!config.xalaynix.enable) {
      xalaynix.desktop.enable = lib.mkForce false;
    };
  };
}