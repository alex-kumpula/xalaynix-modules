{ inputs, ... }:
{
  flake.modules.nixos.xalaynix = 
  { options, config, lib, ... }:
  let
    cfg = config.xalaynix;
  in
  {
    options.xalaynix.hostName = lib.mkOption {
      type = lib.types.string;
      default = "unamed-host";
      description = '' 
        The networking hostname of the system.
      '';
    };

    config = {
      networking.hostname = cfg.hostName;
    };
  };
}