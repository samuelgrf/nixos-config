let
  common = { stdenvNoCC, fetchzip, version, sha256 }:

    stdenvNoCC.mkDerivation {
      pname = "wine-lutris";
      inherit version;

      src = fetchzip {
        url =
          "https://github.com/lutris/wine/releases/download/lutris-${version}/wine-lutris-fshack-${version}-x86_64.tar.xz";
        inherit sha256;
      };

      installPhase = "cp -r $src $out";
      dontFixup = true;
    };
in _: prev: {

  winePackages_lutris = {

    latest = prev.callPackage common {
      version = "7.1";
      sha256 = "sha256-9gIM54ZEeyPUV5Fc9Yas8xXsQhx6lQeRLoZIX89bEes=";
    };
    v7_1 = prev.callPackage common {
      version = "7.1";
      sha256 = "sha256-9gIM54ZEeyPUV5Fc9Yas8xXsQhx6lQeRLoZIX89bEes=";
    };
  };
}
