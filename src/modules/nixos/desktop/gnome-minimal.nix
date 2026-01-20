{ self, lib, ... }:
{
  flake.modules.nixos.xalaynix = 
  { config, lib, ... }:
  let
    cfg = config.xalaynix.desktop;
  in
  {
    config = lib.mkIf (cfg == "gnome-minimal") {
      services.desktopManager.gnome.enable = lib.mkDefault true;
      services.xserver.enable = lib.mkDefault true;
    };
  };
}