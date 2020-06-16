{ mkDerivation, lib, fetchgit, cmake, pkgconfig, git
, qtbase, qtquickcontrols, openal, glew, vulkan-headers, vulkan-loader, libpng, ffmpeg, libevdev, python3
, pulseaudioSupport ? true, libpulseaudio
, waylandSupport ? true, wayland
, alsaSupport ? true, alsaLib
}:

let
  majorVersion = "0.0.10-dev";
  gitVersion = "10427-865180e63"; # echo $(git rev-list HEAD --count)-$(git rev-parse --short HEAD)
in
mkDerivation {
  pname = "rpcs3";
  version = "${majorVersion}-${gitVersion}";

  src = fetchgit {
    url = "https://github.com/RPCS3/rpcs3";
    rev = "865180e63e10b5336ca062829d6b1fad8618a3c7";
    sha256 = "0l1f7hmwxfsayjwj9l9q90vsclg9sihg99ykxw78vqc81xkmznzz";
  };

  preConfigure = ''
    cat > ./rpcs3/git-version.h <<EOF
    #define RPCS3_GIT_VERSION "${gitVersion}"
    #define RPCS3_GIT_BRANCH "HEAD"
    #define RPCS3_GIT_FULL_BRANCH "RPCS3/rpcs3/master"
    #define RPCS3_GIT_VERSION_NO_UPDATE 1
    EOF
  '';

  cmakeFlags = [
    "-DUSE_SYSTEM_LIBPNG=ON"
    "-DUSE_SYSTEM_FFMPEG=ON"
    "-DUSE_NATIVE_INSTRUCTIONS=OFF"
  ];

  nativeBuildInputs = [ cmake pkgconfig git ];

  buildInputs = [
    qtbase qtquickcontrols openal glew vulkan-headers vulkan-loader libpng ffmpeg libevdev python3
  ] ++ lib.optional pulseaudioSupport libpulseaudio
    ++ lib.optional alsaSupport alsaLib
    ++ lib.optional waylandSupport wayland;

  enableParallelBuilding = true;

  meta = with lib; {
    description = "PS3 emulator/debugger";
    homepage = "https://rpcs3.net/";
    maintainers = with maintainers; [ abbradar nocent ];
    license = licenses.gpl2;
    platforms = [ "x86_64-linux" ];
  };
}