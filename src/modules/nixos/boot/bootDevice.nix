{ ... }:
{
  flake.modules.nixos.xalaynix = 
  { lib, config, ... }: 
  let
    cfg = config.xalaynix.boot;
  in
  {
    options.xalaynix.boot.bootDevice = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = '' 
        The path of the device that the bootloader should reside on.
        Example: "/dev/vda"
      '';
    };

    config = lib.mkIf (cfg.enable) { 
      assertions = [
        {
          assertion = cfg.bootDevice != "";
          message = "xalaynix.boot.enable is true, but xalaynix.boot.bootDevice is not set. Please provide a device path (e.g., \"/dev/sda\").";
        }
      ];
    };
  };
}