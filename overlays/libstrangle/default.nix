{ nixpkgs-unstable }:

_: prev:
with prev; {

  libstrangle = callPackage "${nixpkgs-unstable}/pkgs/tools/X11/libstrangle" {
    stdenv = stdenv_32bit;
  };

}
