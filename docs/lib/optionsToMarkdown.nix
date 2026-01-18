{ ... }:
{
  flake.lib = {
    optionsToMarkdown = { 
      pkgs, 
      optionsJSON, 
      includePrefixes ? [ "" ],
      excludePrefixes ? [ ]
    }:
    let
      # Ensure we always have a valid list to pass to toJSON
      safeIncludes = if includePrefixes == [ ] then [ "" ] else includePrefixes;
    in
    pkgs.runCommand "options.md" { 
      nativeBuildInputs = [ pkgs.jq ]; 
      # Passing as environment variables for jq to pick up via --argjson
      pJson = builtins.toJSON safeIncludes;
      eJson = builtins.toJSON excludePrefixes;
    } ''
      jq -r \
        --argjson prefixes "$pJson" \
        --argjson exclusions "$eJson" \
        '
        to_entries
        # Filter 1: Include (If any prefix matches)
        | map(select(.key as $k | $prefixes | any($k | startswith(.))))
        
        # Filter 2: Exclude (If none of the exclusions match)
        | map(select(.key as $k | $exclusions | all($k | startswith(.) | not)))
        
        | .[]
        | (
            .value.description // "" 
            | gsub("{var}`(?<v>[^`]+)`"; "`\(.v)`") 
            | gsub("{option}`(?<o>[^`]+)`"; "**\(.o)**")
          ) as $desc
        | "## \(.key)\n\n" + $desc + "\n\n" +
          "**Type:** `\(.value.type)`\n\n" +
          (if .value.default != null then "**Default:** `\(if .value.default | type == "object" then .value.default.text else .value.default end)`\n\n" else "" end) +
          (if (.value.declarations | length > 0) then "**Declared by:**\n\n" + (.value.declarations | map("- [\(.name)](\(.url))") | join("\n")) + "\n\n" else "" end)
      ' "${optionsJSON}" > $out
    '';
  };
}