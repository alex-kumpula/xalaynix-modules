{ inputs, config, ... }:
{
  flake.modules.homeManager.xalaynix = 
  { pkgs, config, lib, ... }:
  {
    options.xalaynix.shell.test = lib.mkOption {
      type = lib.types.attrs;
      description = "Configuration options for shell integrations.";
      default = { };
    };
  };
}
