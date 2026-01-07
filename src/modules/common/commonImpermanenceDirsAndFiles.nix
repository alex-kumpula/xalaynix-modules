{ inputs, ... }:
{
  flake.modules.nixos.xalaynix = 
  { options, config, lib, ... }: 
  {
    options.xalaynix.commonPersistentDirectories = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = ''
        A list of directories (paths) that should be persisted across reboots 
        using impermanence, such as /var/log or /etc/nixos.
      '';
    };

    options.xalaynix.commonPersistentFiles = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = ''
        A list of individual files (paths) that should be persisted across reboots, 
        such as /etc/machine-id.
      '';
    };

    config.xalaynix.commonPersistentDirectories = [
      "/var/lib/nixos"                # To persist NixOS state 
      "/var/lib/systemd/coredump"     # To persist coredumps 
      "/var/lib/systemd/timers"       # To persist timer states 
      "/var/lib/udisks2"              # To persist USB device authorizations
      "/var/log"                      # To persist logs 
      "/home"                         # To persist user data 
    ];
    
    config.xalaynix.commonPersistentFiles = [
      "/etc/machine-id"
    ];
    
  };
}