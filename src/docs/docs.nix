{ inputs, ... }:
{
  perSystem = { config, pkgs, lib, ... }: {
    packages.docs = let
      # 1. Evaluate your modules. 
      # Adjust 'self.nixosModules.default' to whatever path exports your modules.
      eval = lib.evalModules {
        modules = [
          inputs.self.modules.nixos.xalaynix
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

        transformOptions = opt: opt // {
          declarations = map (decl: 
            let
              # Use inputs.self for the most accurate path matching
              selfPath = toString inputs.self;
              declStr = toString decl;
              
              githubUser = "alex-kumpula";
              repoName = "xalaynix-modules";
              branch = "main"; 
            in
            if lib.hasPrefix selfPath declStr
            then 
              let
                # Clean up the path and strip metadata
                subPath = lib.removePrefix selfPath declStr;
                pathOnly = lib.head (lib.splitString " via option " subPath);
                
                # Build the exact URL
                url = "https://github.com/${githubUser}/${repoName}/blob/${branch}${pathOnly}";
              in
              # We return a string that looks like Markdown to mdBook, 
              # but looks like "just text" to the Nix doc generator.
              "[.${pathOnly}](${url})"
            else 
              "nixpkgs"
          ) opt.declarations;
        };


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