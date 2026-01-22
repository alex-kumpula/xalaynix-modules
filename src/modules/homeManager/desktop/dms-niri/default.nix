{ self, lib, ... }:
{
  flake.modules.homeManager.xalaynix = 
  { config, lib, ... }:
  let
    cfg = config.xalaynix.desktop;
  in
  {
    options.xalaynix.desktop.dms-niri.enable = lib.mkOption {
      type = lib.types.bool;
      description = ''
        Whether to enable a Dank Material Shell for Niri.
      '';
      default = false;
    };
  };
}