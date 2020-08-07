{ alsaLib, cmake, fetchFromGitHub, glib, gettext, gtk2, harfbuzz, lib, libaio
, libpng, libpcap, libxml2, makeWrapper, perl, pkgconfig, portaudio
, SDL2, soundtouch, stdenv, udev, wxGTK, zlib
}:

stdenv.mkDerivation rec {
  pname = "pcsx2";
  version = "unstable-2020-08-02";

  src = fetchFromGitHub {
    owner = "beaumanvienna";
    repo = "pcsx2";
    rev = "38ce40b71c497e7d0fb7997041599661648a364d";
    sha256 = "1sd5pqfaakv4x5ib6h1a5sdzrhyyzx727s2by72698v3nxlx45vp";
  };

  postPatch = "sed '1i#include \"x86intrin.h\"' -i common/src/x86emitter/cpudetect.cpp";

  cmakeFlags = [
    "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}"
    # Makes binaries more portable, commented out for better performance.
    # "-DDISABLE_ADVANCE_SIMD=TRUE"
    "-DDISABLE_PCSX2_WRAPPER=TRUE"
    "-DDOC_DIR=${placeholder "out"}/share/doc/pcsx2"
    "-DGAMEINDEX_DIR=${placeholder "out"}/share/pcsx2"
    "-DGLSL_SHADER_DIR=${placeholder "out"}/share/pcsx2"
    "-DwxWidgets_LIBRARIES=${wxGTK}/lib"
    "-DwxWidgets_INCLUDE_DIRS=${wxGTK}/include"
    "-DwxWidgets_CONFIG_EXECUTABLE=${wxGTK}/bin/wx-config"
    "-DPACKAGE_MODE=TRUE"
    "-DPLUGIN_DIR=${placeholder "out"}/lib/pcsx2"
    "-DREBUILD_SHADER=TRUE"
    "-DXDG_STD=TRUE"
    "-DGTK2_GLIBCONFIG_INCLUDE_DIR=${glib.out}/lib/glib-2.0/include"
    "-DGTK2_GDKCONFIG_INCLUDE_DIR=${gtk2.out}/lib/gtk-2.0/include"
    "-DGTK2_INCLUDE_DIRS=${gtk2.dev}/include/gtk-2.0"
    "-DGTK3_API=FALSE"
    "-DENABLE_TESTS=FALSE" # Needed on 64-bit fork.
  ];

  postFixup = ''
    wrapProgram $out/bin/PCSX2 \
      --set __GL_THREADED_OPTIMIZATIONS 1 \
      --set GTK2_RC_FILES "" # Workaround GTK2 errors on KDE Plasma.
  '';

  nativeBuildInputs = [ cmake makeWrapper perl pkgconfig ];

  buildInputs = [
    alsaLib
    glib
    gettext
    gtk2
    harfbuzz
    libaio
    libpcap
    libpng
    libxml2
    portaudio
    SDL2
    soundtouch
    udev
    wxGTK
    zlib
  ];

  meta = with stdenv.lib; {
    description = "Playstation 2 emulator";
    longDescription= ''
      PCSX2 is an open-source PlayStation 2 (AKA PS2) emulator. Its purpose
      is to emulate the PS2 hardware, using a combination of MIPS CPU
      Interpreters, Recompilers and a Virtual Machine which manages hardware
      states and PS2 system memory. This allows you to play PS2 games on your
      PC, with many additional features and benefits.
    '';
    homepage = "https://pcsx2.net";
    maintainers = with maintainers; [ hrdinka ];

    # PCSX2's source code is released under LGPLv3+. It However ships
    # additional data files and code that are licensed differently.
    # This might be solved in future, for now we should stick with
    # license.free
    license = licenses.free;
    platforms = platforms.linux;
  };
}
