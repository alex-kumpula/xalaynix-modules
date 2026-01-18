{ inputs, ... }:
{
  perSystem = { config, pkgs, lib, ... }: 
  let
    rawOptionsJSON = inputs.self.lib.mkOptionsJSON {
      inherit pkgs;
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

    filteredJson = inputs.self.lib.filterOptionsJSON {
      inherit pkgs;
      optionsJSON = linkedJson;
      includePrefixes = [ "xalaynix" ];
      excludePrefixes = [ "_module" ];
    };

    optionsMarkdown = inputs.self.lib.optionsToMarkdown {
      inherit pkgs;
      optionsJSON = filteredJson;
    };
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
