{ inputs, config, ... }:
{
  flake.modules.homeManager.xalaynix = 
  { pkgs, config, lib, ... }:
  {
    options.xalaynix.shell = lib.mkOption {
      type = lib.types.attrs;
      description = "Configuration options for shell integrations.";
      default = { };
    };
  };
}
