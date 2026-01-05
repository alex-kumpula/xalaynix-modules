{ self, lib, ... }:
{
  flake.modules.nixos.git = 
    { 
      config, 
      lib, 
      ... 
    }: 
    {
      options.xalaynix.git = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Enable simple git configuration.";
        };
      };

      config = {
        programs.git = {
          enable = config.xalaynix.git.enable;
        };
      };
    };
}