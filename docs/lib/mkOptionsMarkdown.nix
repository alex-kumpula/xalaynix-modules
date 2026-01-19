{ inputs, ... }:
{
  flake.lib.mkOptionsBook = { 
    pkgs, 
    module, 
    flakeRoot, 
    githubInfo, 
    includePrefixes ? [ "" ], 
    excludePrefixes ? [ ],
  }:
  let
    rawOptionsJSON = inputs.self.lib.mkOptionsJSON {
      inherit pkgs module;
    };

    linkedJson = inputs.self.lib.mapOptionsToGithub {
      inherit pkgs flakeRoot githubInfo;
      optionsJSON = rawOptionsJSON;
    };

    filteredJson = inputs.self.lib.filterOptionsJSON {
      inherit pkgs includePrefixes excludePrefixes;
      optionsJSON = linkedJson;
    };

    optionsMarkdown = inputs.self.lib.optionsToMarkdown {
      inherit pkgs;
      optionsJSON = filteredJson;
    };
  in
    pkgs.runCommand "options-reference.md" { } ''
      cp ${optionsMarkdown} $out
    '';
}
