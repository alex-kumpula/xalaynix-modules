{ self, lib, ... }:
{
  flake.modules.nixos.xalaynix = 
  { config, lib, ... }: 
  {
    options.xalaynix.desktop = lib.mkOption {
      type = lib.types.enum [ "none" "gnome-minimal" ];
      description = ''
        The desktop environment to use. 
        "gnome-minimal" enables a minimal GNOME desktop environment.
        "none" does nothing.
      '';
      default = "none";
    };

    config = lib.mkIf (!config.xalaynix.enable) {
      xalaynix.desktop = lib.mkForce "none";
    };
  };
}