{ self, lib, ... }:
{
  flake.modules.nixos.xalaynix = 
  { config, lib, ... }:
  let
    cfg = config.xalaynix.desktop;
  in
  {
    options.xalaynix.desktop.gnome-minimal = lib.mkOption {
      type = lib.types.bool;
      description = ''
        Whether to enable a minimal GNOME desktop environment.
      '';
      default = false;
    };

    config = lib.mkIf (cfg.enable && cfg.gnome-minimal) {
      services.desktopManager.gnome.enable = lib.mkDefault true;
      services.xserver.enable = lib.mkDefault true;
    };
  };
}