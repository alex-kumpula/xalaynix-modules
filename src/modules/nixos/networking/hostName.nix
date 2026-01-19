{ inputs, ... }:
{
  flake.modules.nixos.xalaynix = 
  { options, config, lib, ... }:
  let
    cfg = config.xalaynix;
  in
  {
    options.xalaynix.hostName = lib.mkOption {
      type = lib.types.str;
      default = "unamed-host";
      description = '' 
        The networking hostname of the system.
      '';
    };

    config = {
      networking.hostName = cfg.hostName;
    };
  };
}