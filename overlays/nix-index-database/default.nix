_: prev: {

  nix-index-database = prev.callPackage ({ stdenv, lib, fetchurl }:

    stdenv.mkDerivation rec {
      pname = "nix-index-database";
      version = "unstable-2021-12-12";

      src = fetchurl {
        url = "https://github.com/Mic92/nix-index-database/releases/download/${
            lib.removePrefix "unstable-" version
          }/index-x86_64-linux";
        sha256 = "sha256-+SoG5Qz2KWA/nIWXE6SLpdi8MDqTs8LY90fGZxGKOiA=";
      };

      dontUnpack = true;

      installPhase = "cp $src $out";
    }) { };
}
