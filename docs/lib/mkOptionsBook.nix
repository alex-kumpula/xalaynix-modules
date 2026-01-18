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
      inherit pkgs flakeRoot githubInfo;
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

    # Capture version info
    # shortRev will be the git hash, or "dirty" if uncommitted
    version = if (flakeRoot ? shortRev) then flakeRoot.shortRev else "dirty";
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

      # Update Version placeholders in index.md
      if [ -f build/src/index.md ]; then
        substituteInPlace build/src/index.md \
          --replace "{{VERSION}}" "${version}"
      fi
      
      cd build
      mdbook build -d $out
    '';

    dontInstall = true;
  };
}