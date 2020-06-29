{ stdenv, fetchFromGitHub
, meson
, ninja
, cmake
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "inih";
  version = "r48";

  src = fetchFromGitHub {
    owner = "benhoyt";
    repo = "inih";
    rev = "${version}";
    sha256 = "0517kxhvh6q39iyk1dj1dyp5anawdynlzv6zxx736x4mgf6i2f3k";
  };

  nativeBuildInputs = [ cmake meson ninja pkg-config ];

  configurePhase = "meson build --prefix=$out";
  buildPhase = "ninja -C build";
  installPhase = ''
    ninja -C build install
  '';

  meta = with stdenv.lib; {
    description = "Simple .INI file parser in C, good for embedded systems.";
    platforms = platforms.linux;
  };
}
