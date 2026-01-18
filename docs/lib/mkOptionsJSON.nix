{ ... }:
{
  flake.lib = 
  {
    mkOptionsJSON = { pkgs, lib, module, flakeRoot }: 
    let
      optionsDoc = pkgs.nixosOptionsDoc {
        inherit (module) options;
      };
    in "${optionsDoc.optionsJSON}/share/doc/nixos/options.json";
  };
}