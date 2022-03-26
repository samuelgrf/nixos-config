_final: prev: {

  nix-index-database = prev.callPackage ({ stdenvNoCC, lib, fetchurl }:

    stdenvNoCC.mkDerivation rec {
      pname = "nix-index-database";
      version = "unstable-2022-03-20";

      src = fetchurl {
        url = "https://github.com/Mic92/nix-index-database/releases/download/${
            lib.removePrefix "unstable-" version
          }/index-x86_64-linux";
        sha256 = "sha256-wnIPca+dmr6zeWvQ31uQohEdcrkTh8AIw7GSMIKafII=";
      };

      dontUnpack = true;

      installPhase = "cp $src $out";
    }) { };
}
