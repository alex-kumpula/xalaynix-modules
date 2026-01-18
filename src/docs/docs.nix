{ inputs, ... }:
{
  perSystem = { config, pkgs, lib, ... }: {
    packages.docs = let

      eval = lib.evalModules {
        modules = [
          inputs.self.modules.nixos.xalaynix
          {
            # This prevents errors when the config block refers 
            # to options that don't exist in this minimal evaluation.
            _module.check = false;
          }
        ];
      };

      # Transform the evaluated options into Markdown
      optionsDoc = pkgs.nixosOptionsDoc {
        inherit (eval) options;

      
      };

      
    in
      pkgs.stdenv.mkDerivation {
        name = "xalaynix-manual";

        # We use the current directory (src/docs) as the mdBook source
        src = ./.;

        nativeBuildInputs = [ pkgs.mdbook ];
        
        buildPhase = ''
          # Create a clean build environment
          mkdir -p build/src
          
          # Copy your book config and static content
          # Assumes book.toml and SUMMARY.md are in src/docs/
          cp book.toml build/
          cp -r src/* build/src/ || true
          
          # Inject the Nix-generated options
          cp ${optionsDoc.optionsCommonMark} build/src/options.md
          
          cd build
          mdbook build -d $out
        '';

        dontInstall = true;
      };

    # Optional: Allow 'nix build' to build the docs by default
    packages.default = config.packages.docs;
  };
}