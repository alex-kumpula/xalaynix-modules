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
      excludePrefix ? "" # Default to empty string for easier jq handling
    }:
    pkgs.runCommand "options.md" { 
      nativeBuildInputs = [ pkgs.jq ]; 
    } ''
      jq -r \
        --arg prefix "${modulePrefix}" \
        --arg exclude "${excludePrefix}" \
        '
        to_entries
        # Filter 1: Include only keys starting with modulePrefix
        | map(select(.key | startswith($prefix)))
        
        # Filter 2: Exclude keys starting with excludePrefix (only if exclude is not empty)
        | map(select($exclude == "" or (.key | startswith($exclude) | not)))
        
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