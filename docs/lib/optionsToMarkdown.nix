{ ... }:
{
  flake.lib = 
  {
    optionsToMarkdown = { pkgs, optionsJSON, modulePrefix, githubInfo }: 
      pkgs.runCommand "options.md" { nativeBuildInputs = [ pkgs.jq ]; } ''
        jq -r '
          to_entries | 
          map(select(.key | startswith("${modulePrefix}"))) | 
          .[] |
          (.value.description // "" 
            | gsub("{var}`(?<v>[^`]+)`"; "`\(.v)`") 
            | gsub("{var}(?<v>[a-zA-Z0-9_.-]+)"; "`\(.v)`")
            | gsub("{option}`(?<o>[^`]+)`"; "**\(.o)**")
          ) as $desc |
          "## \(.key)\n\n" + $desc + "\n\n" +
          "Type: `\(.value.type)`\n\n" +
          (if .value.default != null then "Default: `\(if .value.default | type == "object" then .value.default.text else .value.default end)`\n\n" else "" end) +
          (if (.value.declarations | length > 0) then "Declared by:\n\n" + (.value.declarations | map("- [\(.path)](https://github.com/${githubInfo.user}/${githubInfo.repo}/blob/${githubInfo.branch}/\(.path))") | join("\n")) + "\n\n" else "" end)
        ' ${optionsJSON} > $out
      '';
  };
}