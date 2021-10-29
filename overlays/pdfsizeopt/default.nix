_: prev: {

  pdfsizeopt = prev.callPackage ({ stdenv, fetchurl, fetchzip, makeWrapper }:

    stdenv.mkDerivation {
      pname = "pdfsizeopt-bin";
      version = "unstable-2019-05-27";

      src = let rev = "33ec5e5c637fc8967d6d238dfdaf8c55605efe83";
      in fetchurl {
        url =
          "https://raw.githubusercontent.com/pts/pdfsizeopt/${rev}/pdfsizeopt.single";
        hash = "sha256-NY0rMuY7ik5+M4xaeUA53gh4PqLI3c0FiCzWI7LT5z0=";
      };

      deps = fetchzip {
        url =
          "https://github.com/pts/pdfsizeopt/releases/download/2017-01-24/pdfsizeopt_libexec_linux-v3.tar.gz";
        hash = "sha256-sXR+MhcKrGBlF0KdwQiCNct/iG9PPJT1wvWP/X8O9dA=";
      };

      dontUnpack = true;

      nativeBuildInputs = [ makeWrapper ];

      installPhase = ''
        runHook preInstall

        install -Dm755 $src $out/bin/pdfsizeopt
        wrapProgram $out/bin/pdfsizeopt \
          --prefix PATH : "$deps"

        runHook postInstall
      '';
    }) { };
}
