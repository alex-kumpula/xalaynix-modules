{ self, lib, ... }:
{
  flake.modules.nixos.xalaynix = 
  { config, lib, ... }: 
  {
    options.xalaynix.displayManager = lib.mkOption {
      type = lib.types.enum [ "none" "gdm-minimal" ];
      description = ''
        The display manager to use. 
        "gdm-minimal" enables a minimal GNOME display manager.
        "none" does nothing.
      '';
      default = "none";
    };

    config = lib.mkIf (!config.xalaynix.enable) {
      xalaynix.displayManager = lib.mkForce "none";
    };
  };
}