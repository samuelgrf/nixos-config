{ stdenv, fetchFromGitHub
, meson
, ninja
, cmake
, pkgconfig
, systemd
, polkit
, dbus
, inih
}:

stdenv.mkDerivation rec {
  pname = "gamemode";
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

  postPatch = ''
    substituteInPlace daemon/gamemode-tests.c --replace "/usr/bin/gamemoderun" $out/bin/gamemoderun
    '';

  configurePhase = "meson build --prefix=$out -Dwith-systemd-user-unit-dir=$out/lib/systemd/user --libexecdir $out/lib/gamemode";
  buildPhase = "ninja -C build";
  installPhase = ''
    ninja -C build install

    mkdir -p $out/share/doc/${pname}/example
    install -m644 -Dt $out/share/doc/${pname}/example example/gamemode.ini
  '';

  meta = with stdenv.lib; {
    platforms = [ "x86_64-linux" ];
    description = "Optimise Linux system performance on demand.";
  };
}
