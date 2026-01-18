{ ... }:
{
  flake.lib = {
    optionsToMarkdown = { 
      pkgs, 
      optionsJSON, 
      includePrefixes ? [ "" ],
      excludePrefixes ? [ ]
    }:
    pkgs.runCommand "options.md" { 
      nativeBuildInputs = [ pkgs.jq ]; 
      pJson = builtins.toJSON includePrefixes;
      eJson = builtins.toJSON excludePrefixes;
    } ''
      jq -r \
        --argjson prefixes "$pJson" \
        --argjson exclusions "$eJson" \
        '
        to_entries
        # 1. Alphabetical Sort
        | sort_by(.key)

        # 2. Filter: Use a single select that handles both include and exclude
        | map(select(.key as $k |
            # Check if it matches any included prefix
            ( $prefixes | length == 0 or any(. as $p | $k | startswith($p)) )
            and
            # Check if it matches NONE of the excluded prefixes
            ( $exclusions | all(. as $e | $k | startswith($e) | not) )
          ))
        
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



# { ... }:
# {
#   flake.lib = {
#     optionsToMarkdown = { 
#       pkgs, 
#       optionsJSON, 
#       modulePrefix, 
#       excludePrefix ? "" # Default to empty string for easier jq handling
#     }:
#     pkgs.runCommand "options.md" { 
#       nativeBuildInputs = [ pkgs.jq ]; 
#     } ''
#       jq -r \
#         --arg prefix "${modulePrefix}" \
#         --arg exclude "${excludePrefix}" \
#         '
#         to_entries
#         # Filter 1: Include only keys starting with modulePrefix
#         | map(select(.key | startswith($prefix)))
        
#         # Filter 2: Exclude keys starting with excludePrefix (only if exclude is not empty)
#         | map(select($exclude == "" or (.key | startswith($exclude) | not)))
        
#         | .[]
#         | (
#             .value.description // "" 
#             | gsub("{var}`(?<v>[^`]+)`"; "`\(.v)`") 
#             | gsub("{option}`(?<o>[^`]+)`"; "**\(.o)**")
#           ) as $desc
#         | [
#             "## \(.key)",
#             $desc,
#             "**Type:** `\(.value.type)`",
#             (if .value.default != null then 
#               "**Default:** `\(if .value.default | type == "object" then .value.default.text else .value.default end)`" 
#             else empty end),
#             (if (.value.declarations | length > 0) then 
#               "**Declared by:**\n" + (.value.declarations | map("- [\(.name)](\(.url))") | join("\n")) 
#             else empty end)
#           ] 
#         | join("\n\n")
#       ' "${optionsJSON}" > $out
#     '';
#   };
# }