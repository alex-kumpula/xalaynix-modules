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
    # Use the mkOptionsMd function to get the complete .md file
    optionsMarkdown = inputs.self.lib.mkOptionsMd {
      inherit pkgs module flakeRoot githubInfo includePrefixes excludePrefixes;
    };

    # Capture version for the index.md replacement
    version = if (flakeRoot ? shortRev) then flakeRoot.shortRev else "dirty";
  in
  pkgs.stdenv.mkDerivation {
    name = bookName;
    inherit src;
    nativeBuildInputs = [ pkgs.mdbook ]; 

    buildPhase = ''
      mkdir -p build/src
      mkdir -p $out

      # Copy existing book source (SUMMARY.md, index.md, book.toml, etc.)
      cp -r $src/* build/ || true
      chmod -R +w build

      # Inject the pre-processed markdown file into the mdbook source
      cp ${optionsMarkdown} build/src/options.md

      # Update Version placeholders in the introduction page
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