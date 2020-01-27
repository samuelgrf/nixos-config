{ stdenv, meson, ninja, fetchFromGitHub, systemd, pkgconfig, dbus }:

stdenv.mkDerivation rec {
  pname = "gamemode";
  version = "1.5";

  nativeBuildInputs = [ meson ninja pkgconfig ];

  buildInputs = [ systemd dbus ];

  src = fetchFromGitHub {
    owner = "FeralInteractive";
    repo = "gamemode";
    rev = "a95fa9642ecbd21a4402b8b2c5b6ad5a72c8864a";
    sha256 = "1dad20zgzh0njkdan7gnim90kawrhqglrn7l5f7y4jm1zaw93ffl";
    fetchSubmodules = true;
  };

  mesonFlags = "-Dwith-systemd-user-unit-dir=share/systemd/user";

  patches = [ ./gamemoderun.patch ];

  meta = with stdenv.lib; {
    description = "Optimise Linux system performance on demand";
    homepage = https://github.com/FeralInteractive/GameMode/;
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = [ maintainers.leo60228 ];
  };
}
