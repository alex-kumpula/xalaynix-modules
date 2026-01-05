#  :::    :::     :::     :::            :::   :::   ::: ::::    ::: ::::::::::: :::    :::  #
#  :+:    :+:   :+: :+:   :+:          :+: :+: :+:   :+: :+:+:   :+:     :+:     :+:    :+:  #
#   +:+  +:+   +:+   +:+  +:+         +:+   +:+ +:+ +:+  :+:+:+  +:+     +:+      +:+  +:+   #
#    +#++:+   +#++:++#++: +#+        +#++:++#++: +#++:   +#+ +:+ +#+     +#+       +#++:+    #
#   +#+  +#+  +#+     +#+ +#+        +#+     +#+  +#+    +#+  +#+#+#     +#+      +#+  +#+   #
#  #+#    #+# #+#     #+# #+#        #+#     #+#  #+#    #+#   #+#+#     #+#     #+#    #+#  #
#  ###    ### ###     ### ########## ###     ###  ###    ###    #### ########### ###    ###  #

# DO-NOT-EDIT. This file was auto-generated using github:vic/flake-file.
# Use `nix run .#write-flake` to regenerate it.
{
  description = "A collection of various modules you can use in your own Nix configurations.";

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./src);

  inputs = {
    disko = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/disko";
    };
    flake-file.url = "github:vic/flake-file";
    flake-parts = {
      inputs.nixpkgs-lib.follows = "nixpkgs-lib";
      url = "github:hercules-ci/flake-parts";
    };
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager/release-25.11";
    };
    impermanence.url = "github:nix-community/impermanence";
    import-tree.url = "github:vic/import-tree";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-lib.follows = "nixpkgs";
    systems.url = "github:nix-systems/default";
  };

}
