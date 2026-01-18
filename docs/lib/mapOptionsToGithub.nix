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
                # 1. Stringify the declaration
                declStr = toString decl;

                # 2. Extract the path (before " via option")
                pathPart = lib.head (lib.splitString " via option " declStr);
                
                # 3. CLEANING: Remove spaces first, THEN remove the comma
                # Note: lib.trim removes whitespace from both ends
                trimmedPath = lib.trim pathPart;
                cleanPathPart = lib.removeSuffix "," trimmedPath;
                
                root = toString flakeRoot;
                
                # 4. Convert to relative path
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