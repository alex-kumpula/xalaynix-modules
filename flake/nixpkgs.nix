{ ... }:
{
  flake-file = {
    inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    inputs.nixpkgs-lib.follows = "nixpkgs";

    inputs.nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
}