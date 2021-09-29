_: prev:
with prev; {

  nix-index-database = stdenv.mkDerivation rec {
    pname = "nix-index-database";
    version = "2021-09-26";

    src = fetchurl {
      url =
        "https://github.com/Mic92/nix-index-database/releases/download/${version}/index-x86_64-linux";
      hash = "sha256-6tKjxFFLMSG/TutWN29fv6ezHoDfMn9blI4A7cvH5dE=";
    };

    dontUnpack = true;

    installPhase = "cp $src $out";
  };

}
