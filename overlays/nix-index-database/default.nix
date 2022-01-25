_: prev: {

  nix-index-database = prev.callPackage ({ stdenvNoCC, lib, fetchurl }:

    stdenvNoCC.mkDerivation rec {
      pname = "nix-index-database";
      version = "unstable-2022-01-02";

      src = fetchurl {
        url = "https://github.com/Mic92/nix-index-database/releases/download/${
            lib.removePrefix "unstable-" version
          }/index-x86_64-linux";
        sha256 = "sha256-BiQRRMeqz7PO/azL9kwdGzPdNs8eq6Cgo7ekqJIxRCM=";
      };

      dontUnpack = true;

      installPhase = "cp $src $out";
    }) { };
}
