{ ... }:
{
  flake.lib = {
    # Filters the JSON file and returns a new JSON file
    filterOptionsJSON = { 
      pkgs, 
      optionsJSON, 
      includePrefixes ? [ "" ], 
      excludePrefixes ? [ ] 
    }:
    pkgs.runCommand "filtered-options.json" {
      nativeBuildInputs = [ pkgs.jq ];
      pJson = builtins.toJSON includePrefixes;
      eJson = builtins.toJSON excludePrefixes;
    } ''
      jq '
        to_entries
        | sort_by(.key)
        | map(select(.key as $k |
            ( $prefixes | length == 0 or any(. as $p | $k | startswith($p)) )
            and
            ( $exclusions | all(. as $e | $k | startswith($e) | not) )
          ))
        | from_entries
      ' --argjson prefixes "$pJson" --argjson exclusions "$eJson" "${optionsJSON}" > $out
    '';
  };
}