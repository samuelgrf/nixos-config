flakes:
with flakes; {

  lib = nixpkgs.lib // import ../lib { inherit (nixpkgs) lib; };
}
