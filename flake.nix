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

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (
      inputs.import-tree [
        ./src
        ./docs
        ./flake
      ]
    );

  inputs = {
    dgop = {
      url = "github:AvengeMedia/dgop";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dms = {
      url = "github:AvengeMedia/DankMaterialShell/stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-file.url = "github:vic/flake-file";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    import-tree.url = "github:vic/import-tree";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-lib.follows = "nixpkgs";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    xalaynix-wrappers.url = "github:alex-kumpula/xalaynix-wrappers";
  };
}
