{ ... }:
{
  flake.lib = 
  { lib, pkgs }:
  {
    # The core generator function
    mkOptionsDoc = 
      { name
      , src
      , module
      , modulePrefix
      , githubInfo ? { user = ""; repo = ""; branch = "main"; }
      , flakeRoot
      }:
      let
        # Helper to build GitHub links for declarations
        gitHubDeclaration = subpath: {
          url  = "https://github.com/${githubInfo.user}/${githubInfo.repo}/blob/${githubInfo.branch}/${subpath}";
          name = subpath;
        };

        # Generate the NixOS options documentation set
        optionsDoc = pkgs.nixosOptionsDoc {
          inherit (module) options;
          transformOptions = opt:
            if opt ? declarations then
              let
                root = toString flakeRoot;
                toGitDecl = decl:
                  let
                    declStr = toString decl;
                    # Strip the "via option" metadata if it exists
                    pathPart = lib.head (lib.splitString " via option " declStr);
                    relPath = if lib.hasPrefix root pathPart then
                      lib.removePrefix "/" (lib.removePrefix root pathPart)
                    else
                      pathPart;
                  in
                    gitHubDeclaration relPath;
              in
                opt // { declarations = map toGitDecl opt.declarations; }
            else opt;
        };
      in
      pkgs.stdenv.mkDerivation {
        inherit name src;
        nativeBuildInputs = [ pkgs.mdbook pkgs.jq ];

        # We disable phases we don't need
        dontConfigure = true;
        dontInstall = true;

        buildPhase = ''
          mkdir -p build/src
          
          # Copy source files to a writable build directory
          cp -r ./* build/
          
          # Inject the generated options into the book source
          cp ${optionsDoc.optionsJSON}/share/doc/nixos/options.json build/src/options.json

          # Format JSON into Markdown using JQ
          jq -r '
            to_entries | 
            map(select(.key | startswith("${modulePrefix}"))) | 
            .[] |
            (.value.description // "" 
              | gsub("{var}`(?<v>[^`]+)`"; "`\(.v)`") 
              | gsub("{var}(?<v>[a-zA-Z0-9_.-]+)"; "`\(.v)`")
              | gsub("{option}`(?<o>[^`]+)`"; "**\(.o)**")
            ) as $desc |
            "## \(.key)\n\n" + $desc + "\n\n" +
            "Type: `\(.value.type)`\n\n" +
            (if .value.default != null then "Default: `\(if .value.default | type == "object" then .value.default.text else .value.default end)`\n\n" else "" end) +
            (if (.value.declarations | length > 0) then "Declared by:\n\n" + (.value.declarations | map("- [\(.name)](\(.url))") | join("\n")) + "\n\n" else "" end)
          ' build/src/options.json > build/src/options.md

          cd build
          mdbook build -d $out
        '';
      };
  };
}