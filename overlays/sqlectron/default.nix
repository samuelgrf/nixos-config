{ stdenv, fetchurl, makeWrapper, electron_8 }:

stdenv.mkDerivation rec {
  pname = "sqlectron";
  version = "1.31.1";

  src = fetchurl {
    url = "https://github.com/samuelgrf/sqlectron-gui/releases/download/v${version}/sqlectron-${version}.tar.xz";
    sha256 = "1z9lqsm54xdifgqlhx80yb1a5gsdif8g7q7n5djn5h2sf9k4r89k";
  };

  dontBuild = true;

  buildInputs = [ electron_8 makeWrapper ];

  installPhase = ''
    mkdir -p $out/{bin,share/sqlectron}

    cp -r * $out/share/sqlectron
    cp -r share/. $out/share
    rm -r $out/share/sqlectron/{build,share}

    makeWrapper ${electron_8}/bin/electron $out/bin/sqlectron \
      --add-flags $out/share/sqlectron
  '';
}
