_: prev: {

  nix-index-database = prev.callPackage ({ fetchurl, lib, stdenv }:

    stdenv.mkDerivation rec {
      pname = "nix-index-database";
      version = "unstable-2021-10-24";

      src = fetchurl {
        url = "https://github.com/Mic92/nix-index-database/releases/download/${
            lib.removePrefix "unstable-" version
          }/index-x86_64-linux";
        sha256 = "sha256-3X0C4luv6+jZrnt/KEWg25X1J7CLSEbP3itG6j8CV+M=";
      };

      dontUnpack = true;

      installPhase = "cp $src $out";
    }) { };
}
