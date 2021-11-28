_: prev: {

  spacemacs = prev.callPackage ({ stdenv, fetchFromGitHub }:

    stdenv.mkDerivation {
      pname = "spacemacs";
      version = "unstable-2021-11-28";

      src = fetchFromGitHub {
        owner = "syl20bnr";
        repo = "spacemacs";
        rev = "23367d08f890873e77fd9a434c9332cf53d5f9df";
        sha256 = "LgNVHX3qXj892osorfWjEAwon5ahJtRftp/EB3cwklg=";
      };

      dontUnpack = true;

      installPhase = "cp -r $src $out";
    }) { };
}
