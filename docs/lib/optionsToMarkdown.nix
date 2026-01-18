# { ... }:
# {
#   flake.lib = 
#   {
#     optionsToMarkdown = { pkgs, optionsJSON, modulePrefix }:
#       pkgs.runCommand "options.md" { nativeBuildInputs = [ pkgs.jq ]; } ''
#         jq -r '
#           to_entries | 
#           map(select(.key | startswith("${modulePrefix}"))) | 
#           .[] |
#           (.value.description // "" 
#             | gsub("{var}`(?<v>[^`]+)`"; "`\(.v)`") 
#             | gsub("{option}`(?<o>[^`]+)`"; "**\(.o)**")
#           ) as $desc |
#           "## \(.key)\n\n" + $desc + "\n\n" +
#           "Type: `\(.value.type)`\n\n" +
#           (if .value.default != null then "Default: `\(if .value.default | type == "object" then .value.default.text else .value.default end)`\n\n" else "" end) +
#           (if (.value.declarations | length > 0) then "Declared by:\n\n" + (.value.declarations | map("- [\(.name)](\(.url))") | join("\n")) + "\n\n" else "" end)
#         ' ${optionsJSON} > $out
#       '';
#   };
# }

{ ... }:
{
  flake.lib = {
    optionsToMarkdown = { 
      pkgs, 
      optionsJSON, 
      modulePrefix, 
      excludePrefix ? null # New parameter to filter out specific modules
    }:
    let
      # Pass Nix variables into the shell environment to keep the jq script clean
      env = {
        inherit modulePrefix excludePrefix;
        nativeBuildInputs = [ pkgs.jq ];
      };
    in
    pkgs.runCommand "options.md" env ''
      jq -r '
        to_entries
        # Filter 1: Include only keys starting with modulePrefix
        | map(select(.key | startswith($modulePrefix)))
        
        # Filter 2: Exclude keys starting with excludePrefix (if provided)
        | map(select($excludePrefix == null or (.key | startswith($excludePrefix) | not)))
        
        | .[]
        | (
            .value.description // "" 
            | gsub("{var}`(?<v>[^`]+)`"; "`\(.v)`") 
            | gsub("{option}`(?<o>[^`]+)`"; "**\(.o)**")
          ) as $desc
        | [
            "## \(.key)",
            $desc,
            "**Type:** `\(.value.type)`",
            (if .value.default != null then 
              "**Default:** `\(if .value.default | type == "object" then .value.default.text else .value.default end)`" 
            else empty end),
            (if (.value.declarations | length > 0) then 
              "**Declared by:**\n" + (.value.declarations | map("- [\(.name)](\(.url))") | join("\n")) 
            else empty end)
          ] 
        | join("\n\n")
      ' "${optionsJSON}" > $out
    '';
  };
}