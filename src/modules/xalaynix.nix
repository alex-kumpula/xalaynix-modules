{ inputs, ... }:
{
  flake.modules.generic.xalaynix = 
  { lib, ... }: 
  {
    options.xalaynix.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Xalaynix configuration.";
    };
  };

  flake.modules.nixos.xalaynix = {
    imports = [
      inputs.self.modules.generic.xalaynix
    ];
  };

  flake.modules.homeManager.xalaynix = {
    imports = [
      inputs.self.modules.generic.xalaynix
    ];
  };
}