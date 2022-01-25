_: prev: {

  nix-index-database = prev.callPackage ({ stdenvNoCC, lib, fetchurl }:

    stdenvNoCC.mkDerivation rec {
      pname = "nix-index-database";
      version = "unstable-2022-01-23";

      src = fetchurl {
        url = "https://github.com/Mic92/nix-index-database/releases/download/${
            lib.removePrefix "unstable-" version
          }/index-x86_64-linux";
        sha256 = "sha256-PYCpxcfPxX+D1auKUfzrw/t9Lj/5Dz5bsZYZSLIELVY=";
      };

      dontUnpack = true;

      installPhase = "cp $src $out";
    }) { };
}
