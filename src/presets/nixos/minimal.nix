{ self, lib, ... }:
{
  flake.modules.nixos.xalaynix = 
  { config, lib, ... }:
  let
    cfg = config.xalaynix.preset;
  in
  {
    config = lib.mkIf (cfg == "minimal") {
      # Xalaynix modules
      xalaynix.desktop = {
        enable = lib.mkDefault true;
        gnome-minimal.enable = lib.mkDefault true;
      };
      xalaynix.displayManager = lib.mkDefault "gdm-minimal";
      xalaynix.boot.loader = lib.mkDefault "grub-minimal";
      xalaynix.audio.backend = lib.mkDefault "pipewire";

      # Important programs
      programs.git.enable = lib.mkDefault true;

      # Printing
      services.printing.enable = lib.mkDefault true;

      # Networking
      networking.networkmanager.enable = lib.mkDefault true;

      # Localization
      i18n.defaultLocale = lib.mkDefault "en_CA.UTF-8";
      time.timeZone = lib.mkDefault "America/Edmonton";
      services.xserver.xkb = {
        layout = lib.mkDefault "us";
        variant = lib.mkDefault "";
      };

      # Nix settings
      nix.settings = {
        experimental-features = [ "nix-command" "flakes" ];
      };
      nixpkgs.config.allowUnfree = lib.mkDefault true;
    };
  };
}