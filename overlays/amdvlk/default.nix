 { stdenv
, lib
, fetchpatch
, fetchRepoProject
, cmake
, ninja
, patchelf
, perl
, pkgconfig
, python3
, expat
, libdrm
, ncurses
, openssl
, wayland
, xorg
, zlib
}:

with lib;

stdenv.mkDerivation rec {
  pname = "amdvlk";
  version = "2020.Q2.1";

  src = fetchRepoProject {
    name = "${pname}-src";
    # We need to use our own manifest to pin AMDVLK to a specific hash,
    # it references master in the upstream version.
    manifest = "https://gist.github.com/98dadf46125c3581a6660fd6040ca7a4.git";
    # The original manifest is here:
    #manifest = "https://github.com/GPUOpen-Drivers/AMDVLK.git";
    rev = "refs/tags/v-${version}";
    sha256 = "0g9ja0yyq24s1f1ia721m6lhhl88gv8a930sh4xn8wifwy4vh7c7";
  };

  buildInputs = [
    expat
    ncurses
    openssl
    wayland
    xorg.libX11
    xorg.libxcb
    xorg.xcbproto
    xorg.libXext
    xorg.libXrandr
    xorg.libXft
    xorg.libxshmfence
    zlib
  ];

  nativeBuildInputs = [
    cmake
    ninja
    patchelf
    perl
    pkgconfig
    python3
  ];

  rpath = lib.makeLibraryPath [
    libdrm
    stdenv.cc.cc.lib
    xorg.libX11
    xorg.libxcb
    xorg.libxshmfence
  ];

  cmakeDir = "../drivers/xgl";

  prePatch = ''
    sed -i '/-Werror/d' drivers/pal/shared/gpuopen/cmake/AMD.cmake
  '';

  cmakeFlags = [
    "-DBUILD_WAYLAND_SUPPORT=ON"
  ];

  installPhase = ''
    mkdir -p $out/lib $out/share/vulkan/icd.d
    cp icd/amdvlk64.so $out/lib/
    cp ../drivers/AMDVLK/json/Redhat/amd_icd64.json $out/share/vulkan/icd.d/
    substituteInPlace $out/share/vulkan/icd.d/amd_icd64.json --replace \
      '/usr/lib64' "$out/lib"
    patchelf --set-rpath "$rpath" \
      $out/lib/amdvlk64.so
  '';

  # Keep the rpath, otherwise vulkaninfo and vkcube segfault
  dontPatchELF = true;

  meta = with stdenv.lib; {
    description = "AMD Open Source Driver For Vulkan";
    homepage = "https://github.com/GPUOpen-Drivers/AMDVLK";
    license = licenses.mit;
    platforms = platforms.x86_64;
    maintainers = with maintainers; [ Flakebi ];
  };
}
