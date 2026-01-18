{ ... }:
{
  flake.lib = {
    optionsToMarkdown = { 
      pkgs, 
      optionsJSON, 
      includePrefixes ? [ "" ],
      excludePrefixes ? [ ] # Now a list; defaults to empty (exclude nothing)
    }:
    pkgs.runCommand "options.md" { 
      nativeBuildInputs = [ pkgs.jq ]; 
      # Convert Nix lists to JSON strings for jq
      prefixesJSON = builtins.toJSON includePrefixes;
      exclusionsJSON = builtins.toJSON excludePrefixes;
    } ''
      jq -r \
        --argjson prefixes "$prefixesJSON" \
        --argjson exclusions "$exclusionsJSON" \
        '
        to_entries
        # Filter 1: Include if the key starts with ANY of the prefixes
        | map(select(.key as $k | $prefixes | any(startswith($k))))
        
        # Filter 2: Exclude if the key starts with ANY of the exclusion prefixes
        # (Using "all" ensures the key matches NONE of the exclusions)
        | map(select(.key as $k | $exclusions | all(startswith($k) | not)))
        
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