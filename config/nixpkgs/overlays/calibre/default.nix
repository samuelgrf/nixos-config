_final: prev:
with prev; {

  calibre = calibre.overrideAttrs (old: {
    buildInputs = old.buildInputs ++ [ python3Packages.cryptography ];
  });
}
