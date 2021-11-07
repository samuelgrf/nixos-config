_: prev: {

  nix-index-database = prev.callPackage ({ stdenv, lib, fetchurl }:

    stdenv.mkDerivation rec {
      pname = "nix-index-database";
      version = "unstable-2021-11-07";

      src = fetchurl {
        url = "https://github.com/Mic92/nix-index-database/releases/download/${
            lib.removePrefix "unstable-" version
          }/index-x86_64-linux";
        sha256 = "sha256-sGdy90hi+G0HLUYUlnk96GOqDKYsjy6PkuabRWe+V38=";
      };

      dontUnpack = true;

      installPhase = "cp $src $out";
    }) { };
}
