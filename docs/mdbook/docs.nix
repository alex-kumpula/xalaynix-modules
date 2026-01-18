{ inputs, ... }:
{
  perSystem = { config, pkgs, lib, ... }: {
    packages.docs = let

      githubUser = "alex-kumpula";
      githubRepo = "xalaynix-modules";
      githubBranch = "main";
      moduleToDocument = "xalaynix";

      eval = lib.evalModules {
        modules = [
          inputs.self.modules.nixos.xalaynix
          { _module.check = false; }
        ];
      };

      gitHubDeclaration = user: repo: branch: subpath: {
        url  = "https://github.com/${user}/${repo}/blob/${branch}/${subpath}";
        name = subpath;
      };

      optionsDoc = pkgs.nixosOptionsDoc {
        inherit (eval) options;

        transformOptions = opt:
          if opt ? declarations then
          let
            root = toString inputs.self;
            toGitDecl = decl:
              let
                declStr = toString decl;
                pathPart = lib.head (lib.splitString " via option " declStr);
                relPath = if lib.hasPrefix root pathPart then
                  lib.removePrefix "/" (lib.removePrefix root pathPart)
                else
                  pathPart;
              in
                gitHubDeclaration githubUser githubRepo githubBranch relPath;
          in
            opt // { declarations = map toGitDecl opt.declarations; }
        else opt;
      };

    in

    pkgs.stdenv.mkDerivation {
      name = "xalaynix-manual";
      src = ./.;
      nativeBuildInputs = [ pkgs.mdbook pkgs.jq ];

      buildPhase = ''
        mkdir -p build/src
        mkdir -p $out

        cp book.toml build/
        cp -r src/* build/src/ || true

        cp ${optionsDoc.optionsJSON}/share/doc/nixos/options.json build/src/options.json

        jq -r '
          to_entries | 
          map(select(.key | startswith("${moduleToDocument}"))) | 
          .[] |
          
          # Process the description to clean up NixOS-specific tags
          (.value.description // "" 
            | gsub("{var}`(?<v>[^`]+)`"; "`\(.v)`") 
            | gsub("{var}(?<v>[a-zA-Z0-9_.-]+)"; "`\(.v)`")
            | gsub("{option}`(?<o>[^`]+)`"; "**\(.o)**")
          ) as $desc |

          "## \(.key)\n\n" +
          $desc + "\n\n" +
          "Type: `\(.value.type)`\n\n" +
          (if .value.default != null then
            "Default: `\(if .value.default | type == "object" then .value.default.text else .value.default end)`\n\n"
          else "" end) +
          (if (.value.declarations | length > 0) then
            "Declared by:\n\n" +
            (.value.declarations | map("- [\(.name | sub(",$"; ""))](\(.url | sub(",$"; "")))") | join("\n")) + "\n\n"
          else "" end)
        ' build/src/options.json > build/src/options.md

        cd build
        mdbook build -d $out
      '';

      dontInstall = true;
    };

    packages.default = config.packages.docs;
  };
}
