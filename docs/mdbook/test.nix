{ inputs, ... }:
{
  perSystem = { config, pkgs, lib, ... }: 
  let
    rawOptionsJSON = inputs.self.lib.mkOptionsJSON {
      inherit pkgs lib;
      flakeRoot = inputs.self;
      module = lib.evalModules {
        modules = [ inputs.self.modules.nixos.xalaynix { _module.check = false; } ];
      };
    };

    linkedJson = inputs.self.lib.mapOptionsToGithub {
      inherit lib pkgs;
      optionsJSON = rawOptionsJSON;
      flakeRoot = inputs.self;
      githubInfo = { 
        user = "alex-kumpula"; 
        repo = "xalaynix-modules"; 
        branch = "main"; 
      };
    };

    optionsMarkdown = inputs.self.lib.optionsToMarkdown {
      inherit pkgs;
      optionsJSON = linkedJson;
      modulePrefix = "xalaynix";
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

        cp ${rawOptionsJSON} $out/rawOptions.json
        cp ${linkedJson} $out/linkedOptions.json

        cp ${optionsMarkdown} build/src/options.md
        cd build
        mdbook build -d $out
      '';

      dontInstall = true;
    };
  };
}
