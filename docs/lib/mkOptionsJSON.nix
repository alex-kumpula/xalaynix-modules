{ ... }:
{
  flake.lib = 
  {
    mkOptionsJSON = { pkgs, module }: 
    let
      optionsDoc = pkgs.nixosOptionsDoc {
        inherit (module) options;
      };
    in "${optionsDoc.optionsJSON}/share/doc/nixos/options.json";
  };
}