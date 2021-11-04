_: prev: {

  nix-index-database = prev.callPackage ({ stdenv, lib, fetchurl }:

    stdenv.mkDerivation rec {
      pname = "nix-index-database";
      version = "unstable-2021-10-31";

      src = fetchurl {
        url = "https://github.com/Mic92/nix-index-database/releases/download/${
            lib.removePrefix "unstable-" version
          }/index-x86_64-linux";
        sha256 = "sha256-bChh9N3E7JGZ1lQM5W6nnrl5N4mkh9y4yDzCgJzfZQc=";
      };

      dontUnpack = true;

      installPhase = "cp $src $out";
    }) { };
}
