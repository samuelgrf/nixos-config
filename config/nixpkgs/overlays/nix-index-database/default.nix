_: prev: {

  nix-index-database = prev.callPackage ({ stdenvNoCC, lib, fetchurl }:

    stdenvNoCC.mkDerivation rec {
      pname = "nix-index-database";
      version = "unstable-2022-02-19";

      src = fetchurl {
        url = "https://github.com/Mic92/nix-index-database/releases/download/${
            lib.removePrefix "unstable-" version
          }/index-x86_64-linux";
        sha256 = "sha256-4n4x7lJM47/v/6Tc3kxbDKMqIhg9IEwGSs4Q2A1Ld8Q=";
      };

      dontUnpack = true;

      installPhase = "cp $src $out";
    }) { };
}
