_: prev: {

  nix-index-database = prev.callPackage ({ stdenv, lib, fetchurl }:

    stdenv.mkDerivation rec {
      pname = "nix-index-database";
      version = "unstable-2021-11-21";

      src = fetchurl {
        url = "https://github.com/Mic92/nix-index-database/releases/download/${
            lib.removePrefix "unstable-" version
          }/index-x86_64-linux";
        sha256 = "sha256-qTIKBPZE1YRcIQcHS4+5e1GtMpX6F5N/97+BTw1ywCQ=";
      };

      dontUnpack = true;

      installPhase = "cp $src $out";
    }) { };
}
