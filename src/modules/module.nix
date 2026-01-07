{ inputs, ... }:
{
  flake.modules.generic.xalaynix = 
  { lib, ... }: 
  {
    options.xalaynix = lib.mkOption {
      # The type is an attribute set because it will contain sub-options
      type = lib.types.attrs;
      description = ''
        Options for the xalaynix module.
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