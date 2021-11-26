_: prev: {

  spacemacs = prev.callPackage ({ stdenv, fetchFromGitHub }:
    stdenv.mkDerivation {
      pname = "spacemacs";
      version = "unstable-2021-11-20";

      src = fetchFromGitHub {
        owner = "syl20bnr";
        repo = "spacemacs";
        rev = "050221ee35a7dd3f73457a94b192199f57de24b2";
        sha256 = "A4gRj0vfJmum+ESYg4ydH4stAPFDMdAH5sEkvanwGVw=";
      };

      dontUnpack = true;

      installPhase = "cp -r $src $out";
    }) { };
}
