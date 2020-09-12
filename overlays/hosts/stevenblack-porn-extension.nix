{ stdenv, fetchurl }:

let
  rawUrl = "https://raw.githubusercontent.com/StevenBlack/hosts";
in

stdenv.mkDerivation rec {
  pname = "stevenblack-hosts-porn-extension";
  version = "3.0.1";

  srcs = [
    (fetchurl {
      name = "clefspeare13";
      url = "${rawUrl}/${version}/extensions/porn/clefspeare13/hosts";
      sha256 = "0hnpaxs62gk9aq2j67nj2gcbvd45zp0flysa5a5nyrj045vd7rwi";
    })
    (fetchurl {
      name = "sinfonietta";
      url = "${rawUrl}/${version}/extensions/porn/sinfonietta/hosts";
      sha256 = "1kyya7jr6fw0bz7ri0nglg6dmmnxrq40mp3pvlhmdx6g8ifiz35z";
    })
    (fetchurl {
      name = "sinfonietta-snuff";
      url = "${rawUrl}/${version}/extensions/porn/sinfonietta-snuff/hosts";
      sha256 = "1pqbiq5d0pyaspr6jk8krzyqa78vfp4g0wkfj1r6wvv5fnava0yr";
    })
    (fetchurl {
      name = "tiuxo";
      url = "${rawUrl}/${version}/extensions/porn/tiuxo/hosts";
      sha256 = "171rjw4833i6z8h1ssbx8df7b2wyzjhn6af9aknhqmp85l0xfc1f";
    })
  ];

  phases = "installPhase";

  installPhase = ''
    mkdir -p $out/share

    for _src in $srcs; do
      cp "$_src" $out/share/$(stripHash "$_src")
    done
  '';
}
