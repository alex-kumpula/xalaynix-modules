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
        # Filter 1: Keep if the KEY starts with any of the prefixes
        | map(select(.key as $k | $prefixes | any(. == "" or ($k | startswith(.)))))
        
        # Filter 2: Drop if the KEY starts with any of the exclusions
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