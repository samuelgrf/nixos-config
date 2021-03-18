_: prev: {

  steam = prev.steam.override { extraPkgs = _: [ prev.cabextract ]; };

}
