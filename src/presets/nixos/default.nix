{ self, lib, ... }:
{
  flake.modules.nixos.xalaynix = 
  { config, lib, ... }: 
  {
    options.xalaynix.presets = lib.mkOption {
      type = lib.types.enum [ "none" "minimal" ];
      description = ''
        "none" applies no presets. \n
        "minimal" applies a minimal set of presets suitable for lightweight systems.
      '';
      default = "none";
    };

    config = lib.mkIf (!config.xalaynix.enable) {
      xalaynix.presets = lib.mkForce "none";
    };
  };
}