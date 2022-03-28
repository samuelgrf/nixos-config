_final: prev: {

  dxvk-async = prev.callPackage ({ stdenvNoCC, fetchzip }:

    stdenvNoCC.mkDerivation rec {
      pname = "dxvk-async";
      version = "1.10.1";

      src = fetchzip {
        url =
          "https://github.com/Sporif/dxvk-async/releases/download/${version}/dxvk-async-${version}.tar.gz";
        sha256 = "sha256-wWIJ6YgGcmZyDBytRaBQhgwAhE9UPmnVBfahAkkVDlA=";
      };

      installPhase = "cp -r $src $out";
    }) { };
}
