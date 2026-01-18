{ ... }:
{
  flake.lib = 
  {
    optionsToMarkdown = { pkgs, optionsJSON, modulePrefix }:
      pkgs.runCommand "options.md" { nativeBuildInputs = [ pkgs.jq ]; } ''
        jq -r '
          to_entries | 
          map(select(.key | startswith("${modulePrefix}"))) | 
          .[] |
          (.value.description // "" 
            | gsub("{var}`(?<v>[^`]+)`"; "`\(.v)`") 
            | gsub("{option}`(?<o>[^`]+)`"; "**\(.o)**")
          ) as $desc |
          "## \(.key)\n\n" + $desc + "\n\n" +
          "Type: `\(.value.type)`\n\n" +
          (if .value.default != null then "Default: `\(if .value.default | type == "object" then .value.default.text else .value.default end)`\n\n" else "" end) +
          (if (.value.declarations | length > 0) then "Declared by:\n\n" + (.value.declarations | map("- [\(.name)](\(.url))") | join("\n")) + "\n\n" else "" end)
        ' ${optionsJSON} > $out
      '';
  };
}


# jq -r '
#   to_entries | 
#   map(select(.key | startswith("${moduleToDocument}"))) | 
#   .[] |
  
#   # Process the description to clean up NixOS-specific tags
#   (.value.description // "" 
#     | gsub("{var}`(?<v>[^`]+)`"; "`\(.v)`") 
#     | gsub("{var}(?<v>[a-zA-Z0-9_.-]+)"; "`\(.v)`")
#     | gsub("{option}`(?<o>[^`]+)`"; "**\(.o)**")
#   ) as $desc |

#   "## \(.key)\n\n" +
#   $desc + "\n\n" +
#   "Type: `\(.value.type)`\n\n" +
#   (if .value.default != null then
#     "Default: `\(if .value.default | type == "object" then .value.default.text else .value.default end)`\n\n"
#   else "" end) +
#   (if (.value.declarations | length > 0) then
#     "Declared by:\n\n" +
#     (.value.declarations | map("- [\(.name | sub(",$"; ""))](\(.url | sub(",$"; "")))") | join("\n")) + "\n\n"
#   else "" end)
# ' build/src/options.json > build/src/options.md