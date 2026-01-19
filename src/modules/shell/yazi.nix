{ inputs, config, ... }:
{
  flake.modules.homeManager.xalaynix = 
  { pkgs, config, lib, ... }:
  {
    options.xalaynix.shell.yazi = lib.mkOption {
      type = lib.types.bool;
      description = "Whether or not to enable Yazi.";
      default = { };
    };

    config = lib.mkIf config.xalaynix.shell.yazi {
      programs.yazi = {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
      };

      programs.bash = {
        enable = true;

        # Appended to ~/.bashrc
        bashrcExtra = ''
          # Custom stuff here
          alias ll='ls -lah'

          # Yazi shell wrapper (see the Yazi website Getting Started page)
          function y() {
            local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
            yazi "$@" --cwd-file="$tmp"
            IFS= read -r -d '\0' cwd < "$tmp"
            [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
            rm -f -- "$tmp"
          }
        '';

        # Appended to ~/.bash_profile
        profileExtra = ''
          export EDITOR=nano
        '';
      };
    };

    
  };
}
