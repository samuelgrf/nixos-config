{ flakes }:

_: prev: {

  libstrangle =
    prev.callPackage "${flakes.nixpkgs-master}/pkgs/tools/X11/libstrangle" {
      stdenv = prev.stdenv_32bit;
    };

}
