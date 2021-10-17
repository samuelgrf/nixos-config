_: prev:
with prev; {

  nix-index-database = stdenv.mkDerivation rec {
    pname = "nix-index-database";
    version = "unstable-2021-10-17";

    src = fetchurl {
      url = "https://github.com/Mic92/nix-index-database/releases/download/${
          lib.removePrefix "unstable-" version
        }/index-x86_64-linux";
      hash = "sha256-BHDsak8ASm3oTjiQiZ4qf6kSHskwsbGuJ2Pe+C8NKyc=";
    };

    dontUnpack = true;

    installPhase = "cp $src $out";
  };

}
