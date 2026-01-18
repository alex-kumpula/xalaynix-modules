{ inputs, config, lib, flake-parts-lib, ... }:
{
  # Required to define `lib` in multiple files.
  # Otherwise:
  #   The option `flake.lib' is defined multiple times while it's expected to be unique.
  options = {
    flake = flake-parts-lib.mkSubmoduleOptions {
      lib = lib.mkOption {
        type = with lib.types; lazyAttrsOf raw;
        default = { };
      };
    };
  };
}