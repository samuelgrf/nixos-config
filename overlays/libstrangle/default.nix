_: prev: {

  libstrangle = prev.callPackage (

    { fetchFromGitLab, lib, libGL, libX11, stdenv_32bit }:

    stdenv_32bit.mkDerivation rec {
      pname = "libstrangle";
      version = "0.1.1";

      buildInputs = [ libGL libX11 ];

      src = fetchFromGitLab {
        owner = "torkel104";
        repo = pname;
        rev = version;
        sha256 = "135icr544w5ynlxfnxqgjn794bsm9i703rh9jfnracjb7jgnha4w";
      };

      makeFlags = [ "prefix=" "DESTDIR=$(out)" ];

      patches = [ ./nixos.patch ];

      postPatch = ''
        substituteAllInPlace src/strangle.sh
        substituteAllInPlace src/stranglevk.sh
      '';

      meta = with lib; {
        description = "Frame rate limiter for Linux/OpenGL";
        inherit (src.meta) homepage;
        license = licenses.gpl3;
        platforms = [ "x86_64-linux" ];
        maintainers = with maintainers; [ aske ];
      };
    }) { };

}
