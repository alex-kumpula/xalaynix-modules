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


        transformOptions = opts:
          lib.mapAttrs (_: opt:
            if opt ? declarations then
              let
                rev = inputs.self.rev or "main";

                toGitDecl = decl:
                  let
                    # decl example:
                    # /nix/store/...-source/src/modules/foo.nix, via option flake.modules.nixos.xalaynix

                    # 1. Drop the ", via option ..." part
                    pathPart = lib.head (lib.splitString ", via option" decl);

                    # 2. Remove /nix/store/<hash>-source/
                    cleaned =
                      lib.removePrefix "/nix/store/" pathPart;

                    parts = lib.splitString "/" cleaned;

                    # 3. Drop "<hash>-source"
                    relPath =
                      lib.concatStringsSep "/" (lib.drop 1 parts);
                  in
                    # 4. Replace with clean Markdown link
                    "[${relPath}](https://github.com/you/xalaynix/blob/${rev}/${relPath})";
              in
                opt // {
                  declarations = map toGitDecl opt.declarations;
                }
            else
              opt
          ) opts;



      
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