{ ... }:
{
  flake-file = {
    inputs = {
      dms = {
        url = "github:AvengeMedia/DankMaterialShell/stable";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      dgop = {
        url = "github:AvengeMedia/dgop";
        inputs.nixpkgs.follows = "nixpkgs";
      };
    };
  };
}