{ self, lib, ... }:
{
  flake.modules.nixos.xalaynix = 
  { config, lib, ... }: 
  {
    # Enable flakes
    nix.settings = {
      experimental-features = [ "nix-command" "flakes" ];
    };
  };
}