{ ... }:
{
  flake.lib = 
  {
    mkOptionsJSON = { pkgs, lib, module, flakeRoot }: 
    let
      optionsDoc = pkgs.nixosOptionsDoc {
        inherit (module) options;
        transformOptions = opt:
          if opt ? declarations then
            let
              root = toString flakeRoot;
              toGitDecl = decl:
                let
                  declStr = toString decl;
                  pathPart = lib.head (lib.splitString " via option " declStr);
                in {
                  path = if lib.hasPrefix root pathPart 
                          then lib.removePrefix "/" (lib.removePrefix root pathPart)
                          else pathPart;
                };
            in opt // { declarations = map toGitDecl opt.declarations; }
          else opt;
      };
    in "${optionsDoc.optionsJSON}/share/doc/nixos/options.json";
  };
}