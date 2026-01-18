{ inputs, ... }:
{
  flake.lib.mkOptionsBook = { 
    pkgs, 
    lib, 
    module, 
    flakeRoot, 
    githubInfo, 
    includePrefixes ? [ "" ], 
    excludePrefixes ? [ ],
    bookName ? "xalaynix-manual",
    src ? ./. 
  }:
  let
    rawOptionsJSON = inputs.self.lib.mkOptionsJSON {
      inherit pkgs module;
    };

    linkedJson = inputs.self.lib.mapOptionsToGithub {
      inherit lib pkgs flakeRoot githubInfo;
      optionsJSON = rawOptionsJSON;
    };

    filteredJson = inputs.self.lib.filterOptionsJSON {
      inherit pkgs includePrefixes excludePrefixes;
      optionsJSON = linkedJson;
    };

    optionsMarkdown = inputs.self.lib.optionsToMarkdown {
      inherit pkgs;
      optionsJSON = filteredJson;
    };
  in
  pkgs.stdenv.mkDerivation {
    name = bookName;
    inherit src;
    nativeBuildInputs = [ pkgs.mdbook ];

    buildPhase = ''
      mkdir -p build/src
      mkdir -p $out

      # Copy existing book source
      cp -r $src/* build/ || true
      chmod -R +w build

      # Inject the generated options
      cp ${optionsMarkdown} build/src/options.md
      
      cd build
      mdbook build -d $out
    '';

    dontInstall = true;
  };
}