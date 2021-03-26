{ flakes }:

_: prev:
with prev; {

  libstrangle =
    callPackage "${flakes.nixpkgs-unstable}/pkgs/tools/X11/libstrangle" {
      stdenv = stdenv_32bit;
    };

}
