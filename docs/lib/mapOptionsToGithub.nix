{ ... }:
{
  flake.lib = {
    mapOptionsToGithub = { pkgs, optionsJSON, flakeRoot, githubInfo }:
      let
        storePath = builtins.toString flakeRoot;
        baseUrl = "https://github.com/${githubInfo.user}/${githubInfo.repo}/blob/${githubInfo.branch}";
      in
      pkgs.runCommand "linked-options.json" { nativeBuildInputs = [ pkgs.jq ]; } ''
        jq 'map_values(. + {
          declarations: (.declarations | map(
            # 1. Handle string/object and strip trailing metadata (like "via option...")
            (if type == "string" then . else .name end | split(",") | .[0])
            # 2. Strip store paths or local flake root paths
            | sub("^${storePath}/"; "")
            | sub("^/nix/store/[^/]+-source/"; "")
            # 3. Reconstruct as an object with clean name and clean URL
            | { 
                name: ., 
                url: "${baseUrl}/\(.)" 
              }
          ))
        })' ${optionsJSON} > $out
      '';
  };
}