{ inputs, ... }:
{
  flake.modules.homeManager.xalaynix = 
  { config, lib, pkgs, ... }:
  let
    cfg = config.xalaynix.desktop;
  in
  {
    imports = [
      inputs.dms.homeModules.dankMaterialShell.default
    ];

    config = lib.mkIf (cfg.enable && cfg.dms-niri.enable) {
      programs.dankMaterialShell = {
        enable = true;
      };

      home.file.".config/niri/config.kdl" = {
        text = lib.mkAfter ''
          include "dms/alttab.kdl"
          include "dms/colors.kdl"
          include "dms/layout.kdl"
          include "dms/wpblur.kdl"

          // Can uncomment the line below once the next Niri 
          // release adds support for optional includes.
          // include optional=true "dms/binds.kdl"
        '';
      };

      systemd.user.services.dms = {
        Unit = {
          Description = "DankMaterialShell";
          PartOf = [ config.wayland.systemd.target ];
          After = [ config.wayland.systemd.target ];
        };

        Service = {
          ExecStart = lib.getExe inputs.dms.packages.${pkgs.system}.dms-shell + " run --session";
          Restart = "on-failure";
        };

        Install.WantedBy = [ config.wayland.systemd.target ];
      };


      
    };
  };
}