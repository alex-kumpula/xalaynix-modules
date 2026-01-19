{ inputs, ... }:
{
  perSystem = { pkgs, lib, ... }: 
  let 
    bookName = "xalaynix-modules-docs";

    flakeRoot = inputs.self;
    version = if (flakeRoot ? shortRev) then flakeRoot.shortRev else "dirty";

    githubInfo = { 
      user = "alex-kumpula"; 
      repo = "xalaynix-modules"; 
      branch = "main"; 
    };

    src = ./.;

    moduleNixos = lib.evalModules {
      modules = [ 
        inputs.self.modules.nixos.xalaynix 
        { _module.check = false; } 
      ];
    };

    moduleHomeManager = lib.evalModules {
      modules = [ 
        inputs.self.modules.homeManager.xalaynix 
        { _module.check = false; } 
      ];
    };

    includePrefixes = [ "xalaynix" ];
    excludePrefixes = [ "_module" ];

    optionsMdNixos = inputs.self.lib.mkOptionsMd {
      inherit pkgs flakeRoot githubInfo includePrefixes excludePrefixes;
      module = moduleNixos;
    };

    optionsMdHomeManager = inputs.self.lib.mkOptionsMd {
      inherit pkgs flakeRoot githubInfo includePrefixes excludePrefixes;
      module = moduleHomeManager;
    };
  in
  {
    packages.docs = pkgs.stdenv.mkDerivation {
      name = bookName;
      inherit src;
      nativeBuildInputs = [ pkgs.mdbook ]; 

      buildPhase = ''
        mkdir -p build/src
        mkdir -p $out

        # Copy existing book source (SUMMARY.md, index.md, book.toml, etc.)
        cp -r $src/* build/ || true
        chmod -R +w build

        # Inject the pre-processed markdown files into the mdbook source
        cp ${optionsMdNixos} build/src/optionsNixos.md
        cp ${optionsMdHomeManager} build/src/optionsHomeManager.md

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
  };
}