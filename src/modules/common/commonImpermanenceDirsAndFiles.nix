{ inputs, ... }:
{
  flake.modules.nixos.xalaynix = 
  { options, config, lib, ... }: 
  {
    options.xalaynix.commonPersistentDirectories = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "A list of directories that should be persisted across reboots.";
      default = [
        "/var/lib/nixos"
        "/var/lib/systemd/coredump"
        "/var/lib/systemd/timers"
        "/var/lib/udisks2"
        "/var/log"
        "/home"
      ];
    };

    options.xalaynix.commonPersistentFiles = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "A list of individual files that should be persisted across reboots.";
      default = [
        "/etc/machine-id"
      ];
    };
  };
}