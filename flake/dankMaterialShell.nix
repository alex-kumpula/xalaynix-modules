{ ... }:
{
  flake-file = {
    inputs = {
      dms = {
        url = "github:AvengeMedia/DankMaterialShell/stable";
        inputs.nixpkgs.follows = "nixpkgs";
      };
    };
  };
}