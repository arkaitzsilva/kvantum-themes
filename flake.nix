{
  description = "Kvantum themes nix flake.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        entries = builtins.readDir ./.;

        themeDirs =
          builtins.filter
            (name:
              entries.${name} == "directory"
              && builtins.pathExists ./${name}/default.nix
            )
            (builtins.attrNames entries);

        themes =
          builtins.listToAttrs
            (map
              (name: {
                inherit name;
                value = import ./${name}/default.nix {
                  inherit pkgs system;
                };
              })
              themeDirs);
      in {
        packages = themes;
      });
}
