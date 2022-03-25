_final: prev:
with prev.python3Packages; {

  yt-dlp = yt-dlp.overrideAttrs (_: rec {
    pname = "yt-dlp";
    version = "2022.3.8.2";

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-aFRleMGObOh0ULU3adXVt/WiPlIJeEl222x8y/eVSyE=";
    };

    name = "${python.libPrefix}-${pname}-${version}";
  });
}
