_: prev:
with prev; {

  nix-index-database = stdenv.mkDerivation rec {
    pname = "nix-index-database";
    version = "unstable-2021-10-10";

    src = fetchurl {
      url = "https://github.com/Mic92/nix-index-database/releases/download/${
          lib.removePrefix "unstable-" version
        }/index-x86_64-linux";
      hash = "sha256-qDWmTaK+mzznj8ti8W2BiBDXOEXZwfFzi76NEDFRWLc=";
    };

    dontUnpack = true;

    installPhase = "cp $src $out";
  };

}
