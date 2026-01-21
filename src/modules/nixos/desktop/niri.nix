{ self, lib, ... }:
{
  flake.modules.nixos.xalaynix = 
  { config, lib, ... }:
  let
    cfg = config.xalaynix.desktop;
  in
  {
    options.xalaynix.desktop.niri.enable = lib.mkOption {
      type = lib.types.bool;
      description = ''
        Whether to enable Niri.
      '';
      default = false;
    };

    config = lib.mkIf (cfg.enable && cfg.niri.enable) {
      programs.niri.enable = lib.mkDefault true;
      services.xserver.enable = lib.mkDefault true;
    };
  };
}