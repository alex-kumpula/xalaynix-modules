{ ... }:
{
  flake.lib = {
    mapOptionsToGithub = { lib, pkgs, optionsJSON, flakeRoot, githubInfo }:
      let
        # This identifies the local path to strip
        storePath = builtins.toString flakeRoot;
        baseUrl = "https://github.com/${githubInfo.user}/${githubInfo.repo}/blob/${githubInfo.branch}";
      in
      pkgs.runCommand "linked-options.json" { nativeBuildInputs = [ pkgs.jq ]; } ''
        jq 'map_values(. + {
          declarations: (.declarations | map(
            # 1. Get the path (handling both string and object declarations)
            (if type == "string" then . else .name end)
            # 2. Strip store paths or local flake root paths
            | sub("^${storePath}/"; "")
            | sub("^/nix/store/[^/]+-source/"; "")
            # 3. Reconstruct as an object so Markdown generator is happy
            | { 
                name: ., 
                url: "${baseUrl}/\(.)" 
              }
          ))
        })' ${optionsJSON} > $out
      '';
  };
}