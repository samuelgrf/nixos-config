_: prev: {

  spacemacs = prev.callPackage ({ stdenv, fetchFromGitHub }:
    let
      rev = "51611b6e307c9a1c1627c18fbaa03022de07a8ac";
      sha256 = "Kh5CuhfUoL0stAIPDKWkzMrfKgPcIuvvWuee6W889Tw=";

    in stdenv.mkDerivation {
      pname = "spacemacs";
      version = "unstable-2021-11-13";

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
