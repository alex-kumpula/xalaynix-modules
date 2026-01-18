{ inputs, ... }:
{
  perSystem = { config, pkgs, system, ... }: {
    packages.docs2 = inputs.self.lib.mkDocs pkgs.mkOptionsDoc {
      name = "xalaynix-manual";
      src = ./docs; 
      modulePrefix = "xalaynix";
      flakeRoot = inputs.self;
      githubInfo = {
        user = "alex-kumpula";
        repo = "xalaynix-modules";
        branch = "main";
      };
      module = inputs.nixpkgs.lib.evalModules {
        modules = [ inputs.self.modules.nixos.xalaynix { _module.check = false; } ];
      };
    };
  };
}
