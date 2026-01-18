{ ... }:
{
  flake.lib = {
    optionsToMarkdown = { 
      pkgs, 
      optionsJSON, 
      includePrefixes ? [ "" ], # Default to everything
      excludePrefixes ? [ ]      # Default to nothing
    }:
    pkgs.runCommand "options.md" { 
      nativeBuildInputs = [ pkgs.jq ]; 
      # Safety: if includePrefixes is [], jq any() will fail. 
      # We ensure it is at least [ "" ] if empty.
      prefixesJSON = builtins.toJSON (if includePrefixes == [] then [ "" ] else includePrefixes);
      exclusionsJSON = builtins.toJSON excludePrefixes;
    } ''
      jq -r \
        --argjson prefixes "$prefixesJSON" \
        --argjson exclusions "$exclusionsJSON" \
        '
        to_entries
        # 1. Inclusion Filter: Keep if key starts with ANY prefix
        | map(select(.key as $k | $prefixes | any($k | startswith(.))))
        
        # 2. Exclusion Filter: Keep ONLY if key starts with NONE of the exclusions
        | map(select(.key as $k | $exclusions | all($k | startswith(.) | not)))
        
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