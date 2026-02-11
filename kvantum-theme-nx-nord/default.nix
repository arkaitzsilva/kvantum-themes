{ pkgs, system }:

let
  stdenv = pkgs.stdenv;

  themeBase = ./files;
  entries = builtins.readDir themeBase;

  themeNames =
    builtins.filter (name: entries.${name} == "directory")
      (builtins.attrNames entries);

  themes =
    builtins.listToAttrs
      (map (name: {
        inherit name;
        value = stdenv.mkDerivation {
          pname = name;
          version = "1.0";

          src = "${themeBase}/${name}";

          dontBuild = true;

          installPhase = ''
            mkdir -p $out/share/Kvantum
            cp -r $src $out/share/Kvantum/${name}
          '';
        };
      }) themeNames);
in
  themes
