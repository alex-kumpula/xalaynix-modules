{ ... }:
{
  flake.lib = 
  {
    mapOptionsToGithub = { pkgs, lib, optionsJSON, flakeRoot, githubInfo }:
    let
      rawOptions = builtins.fromJSON (builtins.readFile optionsJSON);
      
      gitHubUrl = subpath: "https://github.com/${githubInfo.user}/${githubInfo.repo}/blob/${githubInfo.branch}/${subpath}";

      transform = name: opt: 
        if opt ? declarations then
          opt // {
            declarations = map (decl:
              let
                # Convert to string and strip the "via option..." suffix
                declStr = toString decl;
                pathPart = lib.head (lib.splitString " via option " declStr);
                
                # CLEANING STEP: Remove trailing commas or spaces
                # Some Nix versions add a comma during path coercion
                cleanPathPart = lib.removeSuffix "," (lib.trim lib.removeSuffix " " pathPart);
                
                root = toString flakeRoot;
                
                # Convert to relative path
                relPath = if lib.hasPrefix root cleanPathPart 
                          then lib.removePrefix "/" (lib.removePrefix root cleanPathPart)
                          else cleanPathPart;
              in {
                name = relPath;
                url = gitHubUrl relPath;
              }
            ) opt.declarations;
          }
        else opt;

      mappedOptions = lib.mapAttrs transform rawOptions;
    in
    pkgs.writeText "options-mapped.json" (builtins.toJSON mappedOptions);
  };
}