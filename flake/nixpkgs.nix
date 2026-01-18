{ ... }:
{
  flake-file = {
    inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    inputs.nixpkgs-lib.follows = "nixpkgs";
  };
}