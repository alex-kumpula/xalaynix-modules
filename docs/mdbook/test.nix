{ inputs, ... }:
{
  perSystem = { config, pkgs, lib, ... }: 
  let
    optionsJSON = inputs.self.lib.mkOptionsJSON {
      inherit pkgs lib;
      flakeRoot = inputs.self;
      module = lib.evalModules {
        modules = [ inputs.self.modules.nixos.xalaynix { _module.check = false; } ];
      };
    };

    # optionsMarkdown = inputs.self.lib.optionsToMarkdown {
    #   inherit pkgs optionsJSON;
    #   modulePrefix = "xalaynix";
    #   githubInfo = { 
    #     user = "alex-kumpula"; 
    #     repo = "xalaynix-modules"; 
    #     branch = "main"; 
    #   };
    # };
  in
  {
    packages.docs3 = pkgs.stdenv.mkDerivation {
      name = "xalaynix-manual";
      src = ./.;
      nativeBuildInputs = [ pkgs.mdbook ];

      buildPhase = ''
        mkdir -p build/src
        mkdir -p $out

        cp book.toml build/
        cp -r src/* build/src/ || true

        cp ${optionsJSON} build/src/options.json

        # cp ${"optionsMarkdown"} build/src/options.md
        # cd build
        # mdbook build -d $out
      '';

      dontInstall = true;
    };
  };
}
