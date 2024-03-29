_final: prev: {

  nix-index-database = prev.callPackage ({ stdenvNoCC, lib, fetchurl }:

    stdenvNoCC.mkDerivation rec {
      pname = "nix-index-database";
      version = "unstable-2022-03-27";

      src = fetchurl {
        url = "https://github.com/Mic92/nix-index-database/releases/download/${
            lib.removePrefix "unstable-" version
          }/index-x86_64-linux";
        sha256 = "sha256-6wMOCP6Ju8aWhCVk45r4jvfArmG6liRBZLUogpjIVXM=";
      };

      dontUnpack = true;

      installPhase = "cp $src $out";
    }) { };
}
