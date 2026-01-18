{ ... }:
{
  flake.lib = 
  {
    mapOptionsToGithub = { lib, pkgs, optionsJSON, flakeRoot, githubInfo }:
      let
        # This identifies the exact /nix/store/...-source string for the current environment
        storePath = builtins.toString flakeRoot;
        
        # Helper to clean a single declaration
        cleanDeclaration = decl: rec {
          # Remove the nix store prefix to get the relative path
          name = lib.removePrefix "${storePath}/" decl;
          # Construct the GitHub URL
          url = "https://github.com/${githubInfo.user}/${githubInfo.repo}/blob/${githubInfo.branch}/${name}";
        };
      in
      pkgs.runCommand "linked-options.json" { nativeBuildInputs = [ pkgs.jq ]; } ''
        jq --argjson decls '${builtins.toJSON (map cleanDeclaration (lib.flatten (lib.mapAttrsToList (n: v: v.declarations) (builtins.fromJSON (builtins.readFile optionsJSON)))))}' \
        'map_values(. + {
          declarations: (.declarations | map(
            . as $d | 
            # We match the original declaration name against our cleaned list
            # This is a bit simplified; for high performance, a direct jq sub is better:
            sub("^/nix/store/[^/]+-source/"; "")
          ))
        })' ${optionsJSON} > $out
      '';
  };
}