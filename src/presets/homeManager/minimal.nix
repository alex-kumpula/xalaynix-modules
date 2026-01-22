{ self, lib, ... }:
{
  flake.modules.homeManager.xalaynix = 
  { config, lib, ... }:
  let
    cfg = config.xalaynix.preset;
  in
  {
    config = lib.mkIf (cfg == "minimal") {
      # Xalaynix modules
      xalaynix = {
        desktop.dms-niri.enable = lib.mkDefault true;
        shell.yazi.enable = lib.mkDefault true;
      };

      # Enable home-manager to install and manage itself
      programs.home-manager.enable = lib.mkDefault true;

      # Nicely reload system units when changing configs
      systemd.user.startServices = lib.mkDefault "sd-switch";
      
      # Important programs
      programs.git.enable = lib.mkDefault true;

      # Nix settings
      nixpkgs.config.allowUnfree = lib.mkDefault true;

    };
  };
}