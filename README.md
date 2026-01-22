# Xalaynix Modules
This repository contains the modules I use for all of my NixOS and Home Manager configurations.

The modules are usable in **any** configuration, as they make no assumptions about your host.

Refer to the [documentation](https://alex-kumpula.github.io/xalaynix-modules/index.html) for more information.

## Installation
To install these modules, add the following to your flake's inputs:
```
xalaynix = {
    url = "github:alex-kumpula/xalaynix-modules";
    inputs.nixpkgs.follows = "nixpkgs";
};
```
To access the modules, import them into your configuration.

For NixOS modules:
```
imports = [
    inputs.xalaynix.modules.nixos.xalaynix
];
```

For Home Manager modules:
```
imports = [
    inputs.xalaynix.modules.homeManager.xalaynix
];
```

## Usage
To view the available options, see the [documentation](https://alex-kumpula.github.io/xalaynix-modules/optionsNixos.html).

