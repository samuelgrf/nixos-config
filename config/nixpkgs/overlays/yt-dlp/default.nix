_: prev:
with prev.python3Packages; {

  yt-dlp = yt-dlp.overrideAttrs (old: rec {
    pname = "yt-dlp";
    version = "2022.3.8.2";

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-aFRleMGObOh0ULU3adXVt/WiPlIJeEl222x8y/eVSyE=";
    };

    propagatedBuildInputs = old.propagatedBuildInputs ++ [ brotli ];

    name = "${python.libPrefix}-${pname}-${version}";
  });
}
