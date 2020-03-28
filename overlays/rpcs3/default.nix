{ stdenv, lib, fetchgit, cmake, pkgconfig, git
, qt5, openal, glew, vulkan-headers, vulkan-loader, libpng, ffmpeg, libevdev, python3
, pulseaudioSupport ? true, libpulseaudio
, waylandSupport ? true, wayland
, alsaSupport ? true, alsaLib
}:

let
  majorVersion = "0.0.8";
  gitVersion = "9300-341fdf7eb"; # echo $(git rev-list HEAD --count)-$(git rev-parse --short HEAD)
in
stdenv.mkDerivation {
  pname = "rpcs3";
  version = "${majorVersion}-${gitVersion}";

  src = fetchgit {
    url = "https://github.com/RPCS3/rpcs3";
    rev = "341fdf7eb14763fd06e2eab9a4b2b8f1adf9fdbd";
    sha256 = "1qx97zkkjl6bmv5rhfyjqynbz0v8h40b2wxqnl59g287wj0yk3y1";
  };

  preConfigure = ''
    cat > ./rpcs3/git-version.h <<EOF
    #define RPCS3_GIT_VERSION "${gitVersion}"
    #define RPCS3_GIT_BRANCH "HEAD"
    #define RPCS3_GIT_VERSION_NO_UPDATE 1
    EOF
  '';

  cmakeFlags = [
    "-DUSE_SYSTEM_LIBPNG=ON"
    "-DUSE_SYSTEM_FFMPEG=ON"
    "-DUSE_NATIVE_INSTRUCTIONS=ON"
  ];

  nativeBuildInputs = [ cmake pkgconfig git qt5.wrapQtAppsHook ];

  buildInputs = [
    qt5.qtbase qt5.qtquickcontrols openal glew vulkan-headers vulkan-loader libpng
    ffmpeg libevdev python3
  ] ++ lib.optional pulseaudioSupport libpulseaudio
    ++ lib.optional alsaSupport alsaLib
    ++ lib.optional waylandSupport wayland;

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "PS3 emulator/debugger";
    homepage = "https://rpcs3.net/";
    maintainers = with maintainers; [ abbradar nocent ];
    license = licenses.gpl2;
    platforms = [ "x86_64-linux" ];
  };
}
