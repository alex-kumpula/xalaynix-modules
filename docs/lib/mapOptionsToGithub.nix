{ ... }:
{
  flake.lib = 
  {
    mapOptionsToGithub = { lib, pkgs, optionsJSON, flakeRoot, githubInfo }:
    let
      # Load the JSON data into Nix
      rawOptions = builtins.fromJSON (builtins.readFile optionsJSON);
      
      # Helper to build the URL
      gitHubUrl = subpath: "https://github.com/${githubInfo.user}/${githubInfo.repo}/blob/${githubInfo.branch}/${subpath}";

      # Logic to transform a single option
      transform = name: opt: 
        if opt ? declarations then
          let
            root = toString flakeRoot;
            cleanDecls = map (decl:
              let
                declStr = toString decl;
                # Extract path and strip NixOS "via option" metadata
                pathPart = lib.head (lib.splitString " via option " declStr);
                relPath = lib.removePrefix "/" (lib.removePrefix root pathPart);
              in {
                name = relPath;
                url = gitHubUrl relPath;
              }
            ) opt.declarations;
          in opt // { declarations = cleanDecls; }
        else opt;

      # Apply to all options
      mappedOptions = lib.mapAttrs transform rawOptions;
    in
    # Write it back out to a new JSON file
    pkgs.writeText "options-mapped.json" (builtins.toJSON mappedOptions);
  };
}