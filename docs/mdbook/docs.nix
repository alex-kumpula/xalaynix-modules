{ inputs, ... }:
{
  perSystem = { pkgs, lib, ... }: {
    packages.docs = inputs.self.lib.mkOptionsBook {
      inherit pkgs lib;
      
      flakeRoot = inputs.self;

      src = ./.; # Path to the folder containing the mdBook source files.

      module = lib.evalModules {
        modules = [ 
          inputs.self.modules.nixos.xalaynix 
          { _module.check = false; } 
        ];
      };

      githubInfo = { 
        user = "alex-kumpula"; 
        repo = "xalaynix-modules"; 
        branch = "main"; 
      };

      includePrefixes = [ "xalaynix" ];
      excludePrefixes = [ "_module" ];
    };
  };
}