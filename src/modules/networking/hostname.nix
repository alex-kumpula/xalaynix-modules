{ inputs, ... }:
{
  flake.modules.nixos.xalaynix = 
  { options, config, lib, ... }: 
  {
    options.xalaynix.hostName = lib.mkOption {
      type = lib.types.string;
      default = "unamed-host";
      description = '' 
        The networking hostname of the system.
      '';
    };

    config = {
      networking.hostname = options.xalaynix.hostName;
    };
  };
}