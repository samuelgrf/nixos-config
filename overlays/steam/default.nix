_: prev:
with prev; {

  steam = steam.override { extraPkgs = _: [ cabextract ]; };

}
