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
      inherit pkgs moduleNixos flakeRoot githubInfo includePrefixes excludePrefixes;
    };

    optionsMdHomeManager = inputs.self.lib.mkOptionsMd {
      inherit pkgs moduleHomeManager flakeRoot githubInfo includePrefixes excludePrefixes;
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

        # Inject the pre-processed markdown file into the mdbook source
        cp ${optionsMdHomeManager} build/src/options.md

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




  #   packages.docs = inputs.self.lib.mkOptionsBook {
  #     inherit pkgs lib;

  #     flakeRoot = inputs.self;

  #     src = ./.; # Path to the folder containing the mdBook source files.

  #     module = lib.evalModules {
  #       modules = [ 
  #         inputs.self.modules.nixos.xalaynix 
  #         { _module.check = false; } 
  #       ];
  #     };

  #     githubInfo = { 
  #       user = "alex-kumpula"; 
  #       repo = "xalaynix-modules"; 
  #       branch = "main"; 
  #     };

  #     includePrefixes = [ "xalaynix" ];
  #     excludePrefixes = [ "_module" ];
  #   };
  # };
