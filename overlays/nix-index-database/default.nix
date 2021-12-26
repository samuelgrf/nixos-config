_: prev: {

  nix-index-database = prev.callPackage ({ stdenv, lib, fetchurl }:

    stdenv.mkDerivation rec {
      pname = "nix-index-database";
      version = "unstable-2021-12-26";

      src = fetchurl {
        url = "https://github.com/Mic92/nix-index-database/releases/download/${
            lib.removePrefix "unstable-" version
          }/index-x86_64-linux";
        sha256 = "sha256-dlRW6iLG6OghbmxWDfHciDCPHcn/y7bs9XBY+o6GuP0=";
      };

      dontUnpack = true;

      installPhase = "cp $src $out";
    }) { };
}
