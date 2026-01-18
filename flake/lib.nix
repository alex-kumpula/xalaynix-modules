{ inputs, config, lib, flake-parts-lib, ... }:
{

  # Maybe need the below nix code? 
  # Was in https://github.com/GaetanLepage/nix-config/blob/c97af82e25d96d720d9871c4d31d1479a7d3667e/modules/flake/home-manager.nix
  # But I don't know if it is really needed.
  # Leaving this note here just in case.

  # Required to define `homeConfigurations` in multiple files.
  # Otherwise:
  #   The option `flake.homeConfigurations' is defined multiple times while it's expected to be unique.
  options = {
    flake = flake-parts-lib.mkSubmoduleOptions {
      lib = lib.mkOption {
        type = with lib.types; lazyAttrsOf raw;
        default = { };
      };
    };
  };
}