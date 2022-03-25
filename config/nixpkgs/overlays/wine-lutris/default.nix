let
  common = { stdenvNoCC, fetchzip, version, sha256 }:

    stdenvNoCC.mkDerivation {
      pname = "wine-lutris";
      inherit version;

      src = fetchzip {
        url =
          "https://github.com/lutris/wine/releases/download/lutris-wine-${version}/wine-lutris-fshack-${version}-x86_64.tar.xz";
        inherit sha256;
      };

      installPhase = "cp -r $src $out";
      dontFixup = true;
    };

in _final: prev:
with prev; {

  winePackages = winePackages // {
    lutris = {

      latest = callPackage common {
        version = "7.2";
        sha256 = "sha256-iM1By5QcIue2isRkztqpiN5HUqE92fbOXmN04M1nd7Y=";
      };
      v7_2 = callPackage common {
        version = "7.2";
        sha256 = "sha256-iM1By5QcIue2isRkztqpiN5HUqE92fbOXmN04M1nd7Y=";
      };
    };
  };
}
