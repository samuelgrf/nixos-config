{ stdenv, lib, fetchurl, makeWrapper, msitools, wineWowPackages }:

stdenv.mkDerivation {
  pname = "w7zip";
  version = "19.00";

  # TODO: Add condition for x64 and x86
  # TODO: Look into compiling from source (mingw?)
  src = fetchurl {
    url = "mirror://sourceforge/sevenzip/7z1900-x64.msi";
    sha256 = "1p55jz8lbdy5cym9ijbxa2agpzx6ja9cyk02ndclnsnvxqrk5057";
    /*url = "mirror://sourceforge/sevenzip/7z1900.msi";
    sha256 = "1kc9bsxlqj509ai6h4ys6z1l3qcv7m0jr6688x4v3sn05fjmb7dl";*/
  };

  nativeBuildInputs = [ makeWrapper msitools ];

  buildInputs = [ wineWowPackages.minimal ];

  phases = [ "unpackPhase" "installPhase" ];

  unpackPhase = ''
    msiextract $src -C $out
    mkdir -p $out/share/7-zip-win
    mv $out/Files/7-Zip/* $out/share/7-zip-win
    rm -rf $out/Files
  '';

  installPhase = ''
    mkdir -p $out/bin
    makeWrapper ${wineWowPackages.minimal}/bin/wine $out/bin/7z \
      --add-flags "$out/share/7-zip-win/7z.exe" \
      --set WINEARCH win64
  '';

  meta = with stdenv.lib; {
    description = "Wine runner for 7-Zip";
    homepage = "https://www.7-zip.org/";
    # License set to unfree since we are downloading precompiled binaries
    license = {
      free = false;
      url = "https://7-zip.org/license.txt";
    };
    platforms = platforms.unix;
    # maintainers = with maintainers; [ samuelgrf ];
  };
}
