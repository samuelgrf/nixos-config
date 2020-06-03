{ mkDerivation, lib, fetchgit, cmake, pkgconfig, git
, qtbase, qtquickcontrols, openal, glew, vulkan-headers, vulkan-loader, libpng, ffmpeg, libevdev, python3
, pulseaudioSupport ? true, libpulseaudio
, waylandSupport ? true, wayland
, alsaSupport ? true, alsaLib
}:

let
  majorVersion = "0.0.10-dev";
  gitVersion = "10422-3aa92a34b"; # echo $(git rev-list HEAD --count)-$(git rev-parse --short HEAD)
in
mkDerivation {
  pname = "rpcs3";
  version = "${majorVersion}-${gitVersion}";

  src = fetchgit {
    url = "https://github.com/rxys/rpcs3";
    rev = "3aa92a34b48f8e8bdcaf06418bb0bb4cb9877434";
    sha256 = "1773yf153j3wy3gy6gxw4qjyp7sq349r79ggmn3gaq7vb3lay5nv";
  };

  preConfigure = ''
    cat > ./rpcs3/git-version.h <<EOF
    #define RPCS3_GIT_VERSION "${gitVersion}"
    #define RPCS3_GIT_BRANCH "extra_vram"
    #define RPCS3_GIT_FULL_BRANCH "local_build"
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

  # Prevent file collisions when regular rpcs3 package is installed
  postInstall = ''
    mv $out/bin/rpcs3 $out/bin/rpcs3-extra_vram
    rm -rf $out/share/applications
    rm -rf $out/share/icons
    rm -rf $out/share/metainfo
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "PS3 emulator/debugger";
    homepage = "https://rpcs3.net/";
    maintainers = with maintainers; [ abbradar nocent ];
    license = licenses.gpl2;
    platforms = [ "x86_64-linux" ];
  };
}
