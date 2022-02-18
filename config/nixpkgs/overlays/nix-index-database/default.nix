_: prev: {

  nix-index-database = prev.callPackage ({ stdenvNoCC, lib, fetchurl }:

    stdenvNoCC.mkDerivation rec {
      pname = "nix-index-database";
      version = "unstable-2022-02-06";

      src = fetchurl {
        url = "https://github.com/Mic92/nix-index-database/releases/download/${
            lib.removePrefix "unstable-" version
          }/index-x86_64-linux";
        sha256 = "sha256-HCHrzdicYTgkJIEQcxh0Nv013b3x+scJO89Va1eUBsw=";
      };

      dontUnpack = true;

      installPhase = "cp $src $out";
    }) { };
}
