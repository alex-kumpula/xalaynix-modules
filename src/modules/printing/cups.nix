{ self, lib, ... }:
{
  flake.modules.nixos.xalaynix = 
  { config, lib, ... }: 
  {
    # Enable CUPS to print documents.
    services.printing.enable = true;
  };
}