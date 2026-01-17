{ inputs, ... }:
{
  perSystem = { config, pkgs, lib, ... }: {
    packages.docs = let
      # 1. Evaluate your modules. 
      # Adjust 'self.nixosModules.default' to whatever path exports your modules.
      eval = lib.evalModules {
        modules = [
          inputs.self.modules.nixos 
          {
            # THE FIX: This prevents errors when the config block refers 
            # to options that don't exist in this minimal evaluation.
            _module.check = false;
            # Mock pkgs for modules that expect it in their function arguments
            # _module.args.pkgs = pkgs;
          }
        ];
      };

      # 2. Transform the evaluated options into Markdown
      optionsDoc = pkgs.nixosOptionsDoc {
        inherit (eval) options;
      };
    in
      pkgs.stdenv.mkDerivation {
        name = "xalaynix-manual";
        src = ./docs; # Ensure you have a 'docs' folder in your repo
        nativeBuildInputs = [ pkgs.mdbook ];
        
        buildPhase = ''
          mkdir -p src
          # Inject the generated markdown into your mdBook source
          cp ${optionsDoc.optionsCommonMark} src/options.md
          mdbook build
        '';

        installPhase = ''
          cp -r book $out
        '';
      };

    # Optional: Allow 'nix build' to build the docs by default
    packages.default = config.packages.docs;
  };
}