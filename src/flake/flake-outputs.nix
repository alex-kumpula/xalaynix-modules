{ lib, ... }:
{
  flake-file.outputs = lib.mkForce "inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./src)";
}