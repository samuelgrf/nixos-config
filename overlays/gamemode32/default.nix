{ stdenv_32bit, fetchFromGitHub
, meson
, ninja
, cmake
, pkgconfig
, systemd
, polkit
, dbus
, inih
}:

stdenv_32bit.mkDerivation rec {
  pname = "gamemode32";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "FeralInteractive";
    repo = "gamemode";
    rev = "${version}";
    sha256 = "1gp480c8lqz2i576jibbg7gifibkli3rnhhp1k5yrqsbfbn4qxf7";
  };

  nativeBuildInputs = [ cmake meson ninja pkgconfig ];
  buildInputs = [ systemd dbus inih ];
  propagatedBuildInputs = [ polkit systemd ];

  configurePhase = "meson build --prefix=$out -Dwith-daemon=false -Dwith-examples=false -Dwith-systemd=false -Dwith-util=false --libdir lib32";
  buildPhase = "ninja -C build";
  installPhase = ''
    ninja -C build install
  '';

  meta = with stdenv_32bit.lib; {
    platforms = [ "i686-linux" "x86_64-linux" ];
    description = "Optimise Linux system performance on demand.";
  };
}
