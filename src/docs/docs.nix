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
            declStr = toString decl;
            selfStr = toString inputs.self;
            githubUser = "alex-kumpula";
            repoName = "xalaynix-modules";
            branch = "main"; 
          in
          if lib.hasPrefix selfStr declStr
          then 
            let
              # 1. Strip the store path and the " via option " metadata
              subPath = lib.removePrefix selfStr declStr;
              pathOnly = lib.head (lib.splitString " via option " subPath);
              
              # 2. Build the URL
              url = "https://github.com/${githubUser}/${repoName}/blob/${branch}${pathOnly}";
              
              # 3. Return a PLAIN STRING in Markdown format.
              # This prevents the renderer from treating it as a list item.
            in
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