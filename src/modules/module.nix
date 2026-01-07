{ inputs, ... }:
{
  flake.modules.generic.xalaynix = 
  { lib, ... }: 
  {
    options.xalaynix = lib.mkOption {
      type = lib.types.submodule {
        options = { };
      }; 
      
      description = ''
        Options for the xalaynix module and its sub-modules.
      '';
      default = {};
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