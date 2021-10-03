_: prev:
with prev; {

  nix-index-database = stdenv.mkDerivation rec {
    pname = "nix-index-database";
    version = "2021-10-03";

    src = fetchurl {
      url =
        "https://github.com/Mic92/nix-index-database/releases/download/${version}/index-x86_64-linux";
      hash = "sha256-E7IXunAvoW3T4FfmeOgjfvj+nZTRSd6tfgGzlK/5PTM=";
    };

    dontUnpack = true;

    installPhase = "cp $src $out";
  };

}
