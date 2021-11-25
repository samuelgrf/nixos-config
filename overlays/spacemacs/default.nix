_: prev: {

  spacemacs = prev.callPackage ({ stdenv, fetchFromGitHub }:
    let
      rev = "050221ee35a7dd3f73457a94b192199f57de24b2";
      sha256 = "A4gRj0vfJmum+ESYg4ydH4stAPFDMdAH5sEkvanwGVw=";

    in stdenv.mkDerivation {
      pname = "spacemacs";
      version = "unstable-2021-11-20";

      src = fetchFromGitHub {
        owner = "syl20bnr";
        repo = "spacemacs";
        inherit rev sha256;
      };

      dontUnpack = true;

      installPhase = "cp -r $src $out";

      passthru = { inherit rev sha256; };
    }) { };
}
