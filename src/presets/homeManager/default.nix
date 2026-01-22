{ self, lib, ... }:
{
  flake.modules.homeManager.xalaynix = 
  { config, lib, ... }: 
  {
    options.xalaynix.preset = lib.mkOption {
      type = lib.types.enum [ "none" "minimal" ];
      description = ''
        "none" applies no presets.

        "minimal" applies a minimal set of presets suitable for lightweight systems.
      '';
      default = "none";
    };

    config = lib.mkIf (!config.xalaynix.enable) {
      xalaynix.preset = lib.mkForce "none";
    };
  };
}